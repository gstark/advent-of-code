# Sigil notes from porting Advent of Code 2023

Running log of performance and language findings, gathered while writing `partN.sg` for each day.
Every claim here was measured or hit directly, not inferred.

Benchmark sources are `bench.sg` (maps, arithmetic, records, slicing), `bench2.sg` (lists) and
`bench3.sg` (map-backed stdlib helpers), all run via `sigil exec bench.sg -- <n> <case>`.

Suggested fixes, written up as draft decision entries, are in `~/dev/personal/sigil/PERF-PROPOSALS.md`.

> **Re-measured 2026-07-30, after the fixes.** Four things landed in `sigil` and every number below
> is from a build that has all four: Draft A (`Map` on a persistent tree,
> [D-098](../../personal/sigil/DECISIONS.md)), Draft C (linear `List.uniq`,
> [D-099](../../personal/sigil/DECISIONS.md)), the string work this document's day 14 row prompted
> ([D-100](../../personal/sigil/DECISIONS.md)), and a 5.6x cut to `sigil exec`'s startup
> ([D-101](../../personal/sigil/DECISIONS.md)).
> The original findings are kept, because a document that only shows the fixed state cannot be
> checked and cannot teach anyone what to look for — each section now reads "what was measured, what
> it is now". All 43 programs produce byte-identical output on both builds.
>
> **Method changed with the re-measurement, and it matters when reading the tables.** These numbers
> are the **best of three runs** (best of one for anything over 3s); the original tables were one run
> each. Where before-and-after is claimed below it is an A/B of two binaries measured back to back in
> one session, which is the only comparison that isolates the change.
>
> **Every timing now goes through a harness that fails a run that exits non-zero or prints nothing**,
> rather than through a loop reading the clock — see the method note below, which is the mistake it
> exists to prevent. It caught one: the program used to measure startup did not compile, and its
> "startup" numbers were the cost of a diagnostic.

> Method note, learned the hard way: `sigil exec` exits non-zero on a compile error in ~0.06s, which
> looks exactly like a fast run if the timing loop only greps for `real`. One syntax error in an
> unrelated function invalidated a whole table of list timings before I noticed. Always confirm the
> file compiles and prints its result before trusting a number.

## Performance

### `Map.insert` was O(n), not O(log n) — the big one, and it is fixed

Micro-benchmark: fold `Map.insert` over `List.range(0, n)`, nothing else.

| n | 1000 | 2000 | 4000 | 8000 | 16000 | 200000 |
|---|---|---|---|---|---|---|
| **was** | 0.09s | 0.09s | 0.16s | 0.46s | 1.62s | >4min, killed |
| **now** | 0.018s | 0.018s | 0.019s | 0.022s | 0.030s | **0.200s** |

Doubling `n` multiplied the time by ~3.5, so the total was roughly O(n²) — each insert cost time
proportional to the map's current size, because `Map.insert` copied the whole `BTreeMap` before
adding to it. It is now `imbl::GenericOrdMap`, the persistent B-tree that `List` was already built
on, so the copy is O(log n) and shares structure. The row above is within noise of the process floor
to n=16000, and the 200000 case finishes in a fifth of a second instead of not finishing.

**Lookups were always fine**, and still are: building a map of `n` then doing `n` `Map.has` calls
costs 0.027s at n=8000 against 0.022s for the inserts alone, and 0.303s against 0.200s at n=200000.
The cost was entirely on the write path, which is what made a representation change the whole fix.

This one issue accounted for every slow program in the port:

- **Day 12 part 2**: DP table in a `Map` keyed by a packed `(i, j)` → **27s**. The same table as a
  list of rows indexed positionally → **4.0s**. ~7x, identical answer.
- **Day 16 part 1**: `seen` set of ~48000 `(tile, direction)` states in one flat `Map` → **1.39s**.
  Bucketing into one small `Map` per grid row, so no map exceeds a row's worth of entries →
  **0.13s**. ~10x, identical answer. Part 2 runs 440 such walks: **16.5s** bucketed, and would have
  been roughly ten minutes flat. (That 16.5s is now 9.85s, on the same bucketed code.)

The day 16 result is the sharper diagnostic: the *same* number of inserts, only spread across 110
small maps instead of one big one, is 10x faster. That is the signature of per-insert cost scaling
with map size.

Day 16 also gave a useful negative result. Before finding this, I rewrote the beam walk three ways —
BFS by layers, BFS without the per-layer `uniq`, and a single-beam stack — and all three landed at
1.39s ± 0.01. When restructuring the algorithm changes nothing, the cost is in the data structure.

Day 17 (Dijkstra over ~40000 states) was written against this finding from the start: the frontier is
a bucket queue whose processed buckets are dropped, so it stays roughly one edge-weight wide instead
of growing to the number of queued states, and the distance table is bucketed by row. Both parts landed
under 2.1s, and now under 1.7s. Written naively against one flat distance map it would have been the
day 16 story again.

**What the fix is worth on the real programs**, A/B against a baseline binary, back to back, same
machine, min of N runs — note that every one of these still carries the bucketing workaround it was
written with:

| day | part | before | after | |
|---|---|---|---|---|
| 16 | 2 | 16.23s | **9.85s** | 0.61× |
| 21 | 2 | 6.79s | **4.27s** | 0.63× |
| 17 | 2 | 2.06s | **1.61s** | 0.78× |
| 17 | 1 | 0.97s | **0.69s** | 0.71× |
| 3 | 2 | 0.169s | **0.054s** | 0.32× |
| 12 | 2 | 3.90s | 3.94s | 1.01× |

The last row is the control: day 12's DP table is a `List` of rows, so it touches no large `Map`
and does not move. Day 3 part 2 is the surprise — a 0.17s program that lost two thirds of its time,
from one `uniq` call and one `Map` of gear positions plus the startup fix below. Nobody thought it
was slow.

(These are whole-session numbers: days 16, 21 and 17 are the `Map` fix, day 3 is `Map` and `uniq`
and startup together. Where a single change needs isolating, the entries in `DECISIONS.md` do it.) **A third off the worst program
in the set, while it is still hand-optimised against the problem that no longer exists** — the
naive spellings these programs avoided are the ones that gained most, and they are not in this table
because they were never checked in.

**The standard library inherited it**, since every `Map`-backed helper is a fold over `Map.insert`:

| n | 2000 | 4000 | 8000 | 16000 |
|---|---|---|---|---|
| `List.tally` **was** | 0.10s | 0.16s | 0.45s | 1.63s |
| `List.tally` **now** | 0.020s | 0.023s | 0.026s | 0.034s |
| `Map.from_list` **was** | 0.09s | 0.17s | 0.45s | 1.63s |
| `Map.from_list` **now** | 0.021s | 0.023s | 0.027s | 0.035s |
| `List.group_by` **was** | 0.10s | 0.18s | 0.53s | 1.92s |
| `List.group_by` **now** | 0.021s | 0.022s | 0.027s | 0.036s |

All three are now linear, and at n=16000 they cost about what an empty program does. `Map.merge`, `Map.map_values` and
`Map.filter` have the same shape and came right the same way. None was ever at fault — they all
inherited `insert`, and they all inherited the fix, with no edit to any of them.

### `List.uniq` was quadratic, and it is now linear

| n | 4000 | 8000 | 16000 | 32000 | 64000 | 128000 |
|---|---|---|---|---|---|---|
| **was** | 0.10s | 0.20s | 0.61s | 2.30s | — | — |
| **now** | 0.026s | 0.029s | 0.040s | 0.060s | 0.102s | 0.192s |

It was ×3.7 per doubling — a `contains` scan per element, comparing every pair. It now carries a
`Map` of what it has seen, so it is O(n) with first-occurrence order preserved, and 32000 elements
cost 0.060s instead of 2.30s. Doubling n now doubles the work above the floor, which is the shape it
should have had all along.

Worth keeping the honest measure of what it had cost, because it was less than it looked: day 21
called `.uniq()` on every BFS frontier, and replacing it by hand with a fold that marks each plot as
it is accepted took the 458-step sweep from **15.1s to 12.7s** — real, but only ~16%, because
`Map.insert` was still dominant. The two fixes had to land together for either to show its full
value.

**The catch, and it is a real one.** `uniq` now goes through a `Map`, so an element that holds a
function is `E0618` rather than a silently wrong answer. Nothing in these 43 programs deduplicates a
list of functions, so nothing here changed — but it is a behaviour change and the sigil ledger files
it as one ([D-099](../../personal/sigil/DECISIONS.md)).

### Startup was 47ms of stocking a store the program throws away

Not a language cost at all, and the largest single number in this document once the `Map` fix
landed. `sigil exec` builds a store, adds the file, runs it, deletes the store — and building a
store means installing the standard library (D-069), which is 261 definitions parsed, checked,
hashed and written. Measured:

| | before | after |
|---|---|---|
| `sigil exec` on a program that prints one line | 54ms | **10ms** |
| of which, creating the store and installing the library | 47ms | ~0 (copied) |
| of which, process start | 4ms | 4ms |

The stocked store is now built once and copied. Fixed in
[D-101](../../personal/sigil/DECISIONS.md).

This is why every short row in the Ruby table moved and why the median flipped below 1.0x. It is
also why that median should not be read as a language result: 35 of the 43 programs finish in under
0.15s, and for those this is most of what was being measured all along — on both sides.

### Lists are otherwise excellent — and `Str` concatenation is not

Re-measured with the 0.018s floor, which is the first time these have been visible as curves rather
than as "flat". n doubles left to right:

| operation | 4000 | 8000 | 16000 | 32000 | 64000 | 128000 |
|---|---|---|---|---|---|---|
| `map` | 0.021s | 0.021s | 0.023s | 0.029s | 0.039s | 0.061s |
| `get` (random access) | 0.022s | 0.024s | 0.031s | 0.042s | 0.067s | 0.115s |
| `push` (append in a fold) | 0.021s | 0.023s | 0.026s | 0.034s | 0.050s | 0.085s |
| `[x] ++ acc` (prepend in a fold) | 0.019s | 0.021s | 0.025s | 0.035s | 0.051s | 0.085s |
| `acc ++ [x]` (concat in a fold) | 0.020s | 0.022s | 0.026s | 0.035s | 0.052s | 0.085s |
| `uniq` | 0.026s | 0.029s | 0.040s | 0.060s | 0.102s | 0.192s |
| **`++` on `Str` in a fold** | 0.020s | 0.023s | 0.031s | 0.062s | 0.155s | **0.871s** |

Every list operation is linear once the floor is subtracted — the work per doubling doubles, which
is what it should do. Appending in a fold being cheap is the pleasant surprise, since in a lot of
persistent-list languages that is the classic accidental quadratic; it is why the day 12 DP table
works as a list of rows. `Map` now sits on the same foundation, which is all Draft A ever asked for.

**The last row is the exception, and it is new information.** `acc ++ "x"` in a fold goes ×2.0, ×2.7,
×5.0, ×2.5, ×5.6 per doubling — that is quadratic, because each `++` copies the whole accumulated
string. The old table called it "flat to 16000, slight rise at 32000" and that was the **57ms floor
hiding it**: at n=32000 the quadratic term had only just cleared the noise. Lowering the floor for
an unrelated reason turned a shrug into a finding, which is an argument for lowering it that had
nothing to do with why it was lowered.

This is day 14's shape — a program that rebuilds a grid as strings — and it is the strongest
evidence in this document for `STDLIB-PROPOSALS.md` Draft K. A `Str.join` over a list, or a builder,
would not have this curve.

### Practical guidance this suggests

Rewritten against the fixed build. Three of the five lines below were workarounds for the two
problems above, and all three are gone.

- **`Map` can be used without a second thought**, at any size. `insert`, `remove`, `get` and `has`
  are all O(log n) with structural sharing, and 200000 inserts cost 0.2s.
- **Bucketing a large `Map` is now actively counterproductive** — not merely unnecessary. Measured on
  day 16's shape, 48000 inserts: one flat map **0.10s**, the same inserts spread over 110 buckets of
  440 **0.12s**. The extra `get`-then-insert per element costs more than the shallower trees save. It
  was a 10x win on the old build and it is a small loss on this one, which is the sharpest possible
  statement that the workaround should come out.
- **`List.uniq` is fine now.** It is linear and order-preserving; the fold-and-mark workaround buys
  nothing. It does refuse a list of functions where it used to answer wrongly.
- For a genuinely dense table, a `List` of rows indexed positionally is still the faster shape — day
  12 measures the same on both builds, which is the evidence for it.
- `push`, `++`, `get` and `map` on lists can be used without a second thought, unchanged.
- **New, and the one thing on this list to still avoid: `++` on `Str` in a fold is quadratic.** Build
  a `List[Str]` and `join` it once at the end. This was always true and was hidden by the old process
  floor.

## Language

Things that cost me a compile cycle. None are bugs; a few might be worth a better diagnostic. Two
have since been fixed and are marked; the rest stand.

- **No `&&` / `||`.** It is `and` / `or` / `not`. `&&` failed as a lex error (E0101, "unexpected
  character `&`") rather than a "did you mean `and`". **Fixed:** E0101 on `&` now names `and` and
  `or` outright. `|` is a real token — the sum-variant separator — so `||` is still a parse error
  and does not get the hint.
- **Method sugar does not work on a `const`.** `WORDS.find(...)` resolves as the literal name
  `WORDS.find` and fails with E0402. `List.find(WORDS, ...)` works. Since the receiver's type is
  known, this could probably resolve the same way it does for any other value.
- **No `Str.trim_end`** (only `Str.trim`). Worth having alongside `strip_suffix`.
- **A failed method call cascades.** One `no field trim_end` error produced two further E0201
  "cannot tell what `split` belongs to" errors for everything chained after it. Reporting only the
  first would be less noisy.
- **`fold`'s step is `fn(accumulator, item)`**, and passing a function whose parameters are in the
  other order is a type error rather than a silent swap. Good — worth keeping.
- **`List.zip` yields `{ first, second }` records.** There are no tuples, so `pair.0` is a parse
  error (E0110, "expected a field or method name, found `1`").
- **`Str.code_of` returns `Option[Int]`** and takes one argument, not `(text, index)`.
- **`%` follows the sign of the dividend**, so `-1 % 11` is `-1`, not `10`. Day 21 needs a floored
  modulo to wrap an infinitely repeating grid and has to spell it `(v % n + n) % n`. Worth a
  `Int.rem_euclid` or similar in the standard library — grid wrapping is common enough, and the
  failure is silent rather than an error.
- **`Int.parse` reads decimal only.** Day 18 part 2 hand-folds hex. A radix argument, or
  `Int.parse_radix`, would have saved a function.
- **Builtins are invisible to `sigil view`** (`Str.slice`, `Int.parse`, `List.get`, `Map.*`), so
  their signatures have to be discovered by provoking a type error. `sigil search ""` lists the
  names but not the shapes.
- **Forward references within a file work**, including mutual recursion — day 19 part 2 has `through`
  calling `accepted`, which is defined below it, and it resolves fine. Worth knowing because E0402's
  wording ("not defined earlier in this file") suggested definitions must be ordered, which they need
  not be. **Fixed:** it now reads "not defined anywhere in this file" and says outright that order
  within the file is not the problem.
- **Deep recursion is fine.** A 19000-deep tail-recursive walk (day 8) runs without growing the
  stack, and the day 10 loop walk goes 13466 deep. This made several solutions much cleaner than
  they would otherwise have been.
- **`?` works inside a closure** passed to `fold`, which made threading `Result` through an
  accumulation pleasant (day 15 part 2).

## Things that went well

The capability record (`Sys` with `console` and `fs`) plus `Result[_, Str]` and `try_map` made the
parse-and-fail path uniform across all 43 programs, with no panics anywhere. Structural equality on
records meant grid coordinates, beams and DP keys needed no hand-written comparison. `List.slices`,
`List.windows`, `List.tally` and `List.chunk_while` each removed a hand-rolled loop.

Deep tail recursion being free shaped most of these solutions. Day 8 walks 19000 steps, day 10 traces
a 13466-tile loop, day 17's Dijkstra and day 21's BFS both recurse per step — all written as plain
recursion with an accumulator, with no trampolining and no explicit loop construct. That is the
single feature that made a mutation-free language pleasant for this kind of problem rather than a
fight.

## Ruby vs Sigil, on the same inputs

**Both columns re-measured 2026-07-30**, after the `Map` and `uniq` fixes. Both implementations of
every day, on the real `input.txt`, same machine, same harness: Ruby 3.3.0 (no YJIT) via mise, Sigil
via `sigil exec`, stdout to a pipe, best of three runs (best of one for anything over ~2s). The Ruby
programs did not change; they were re-run so that both columns share a method and the ratios mean
something.

**Read the ratio column with care.** I wrote the Sigil versions without reading the Ruby ones, so
where the two picked different algorithms this table compares *approaches*, not languages. Those rows
are marked. The language signal is in the unmarked rows, and it is:

> **Sigil is now median 0.88x of Ruby** — 21 of the 35 non-divergent pairs are *faster* than Ruby —
> **but that headline is about process startup, not about the language.** Sigil's floor is now
> ~0.018s against Ruby's ~0.035s, and 30 of the 43 programs finish in under 0.15s, so most of this
> table is a race between two runtimes' startup in which Sigil happens to win.
>
> **The language signal is in the four rows where real work dominates** — everything above 0.3s that
> is not algorithm-divergent — and there it is **1.90x, 2.10x, 2.68x, 2.88x**. That is where Sigil
> actually stands against Ruby, and it has barely moved: those same four rows were 1.94x, 2.11x,
> 2.74x, 3.50x before this session's work, so only day 14 improved materially.

The progression across the whole session, like for like on the same Ruby column and the same 35 rows:

| Sigil build | median | range |
|---|---|---|
| before any of it | 2.16x | 1.63x – 4.46x |
| after `Map` and `uniq` ([D-098](../../personal/sigil/DECISIONS.md), [D-099](../../personal/sigil/DECISIONS.md)) | 1.91x | 1.40x – 3.50x |
| after strings and startup ([D-100](../../personal/sigil/DECISIONS.md), [D-101](../../personal/sigil/DECISIONS.md)) | **0.88x** | 0.48x – 2.88x |

The last row is mostly the startup change, and reading it as "Sigil overtook Ruby" would be exactly
the misreading the row above it warns against.

For a young tree-walking VM against a thirty-year-old C interpreter, on a workload that is almost
entirely allocation and collection traffic, ~2x on the rows that measure the language is a good
number. The floors are **~0.035s for Ruby and ~0.018s for Sigil**, so anything under ~0.15s is
measuring startup rather than the program.

> **A measurement trap worth recording, because it cost a whole table.** The first re-run of the Ruby
> column was launched as a background process, and four of its rows came back 2.2–2.4x slower than
> the same programs run in the foreground — day 16 part 2 at 8.72s against 3.69s, day 14 part 2 at
> 2.21s against 0.97s — while the other rows, including day 17's two enormous ones, reproduced
> exactly. Backgrounded work on this machine is not always given the same cores. Everything in this
> document is foreground-measured; a benchmark run from a background job is not comparable to one
> that is not, and the failure is silent and partial, which is the dangerous kind.

**Every pair agrees on the answer.** That is the more valuable result of the exercise — two
independent implementations, written from the puzzle text rather than from each other, in different
languages and often with different algorithms, producing identical output on all 41 shared parts.
Including the two I could not check against Advent of Code: **day 10 part 2 (435)** and **day 12
part 2 (3415570893842)** both match, which is real corroboration for answers that were never
submitted.

| day | part | Ruby 3.3 | Sigil | Sigil / Ruby | note |
|---|---|---|---|---|---|
| 01 | 1 | 0.051s | 0.029s | 0.57x |  |
| 01 | 2 | 0.059s | 0.060s | 1.02x |  |
| 02 | 1 | 0.043s | 0.021s | 0.49x |  |
| 02 | 2 | 0.039s | 0.020s | 0.51x |  |
| 03 | 1 | 0.054s | 0.057s | 1.06x |  |
| 03 | 2 | 0.053s | 0.052s | 0.98x |  |
| 04 | 1 | 0.039s | 0.021s | 0.54x |  |
| 04 | 2 | 0.039s | 0.021s | 0.54x |  |
| 05 | 1 | 0.035s | 0.018s | 0.51x |  |
| 05 | 2 | 0.037s | 0.021s | 0.57x |  |
| 06 | 1 | 0.034s | 0.017s | 0.50x |  |
| 06 | 2 | 0.033s | 0.016s | 0.48x |  |
| 07 | 1 | 0.039s | 0.035s | 0.90x |  |
| 07 | 2 | 0.042s | 0.037s | 0.88x |  |
| 08 | 1 | 0.041s | 0.037s | 0.90x |  |
| 08 | 2 | 0.049s | 0.10s | 2.14x |  |
| 09 | 1 | 0.040s | 0.049s | 1.23x |  |
| 09 | 2 | 0.038s | 0.050s | 1.32x |  |
| 10 | 1 | 0.059s | 0.049s | 0.83x |  |
| 10 | 2 | 0.30s | 0.053s | **0.18x** | shoelace+Pick vs flood fill |
| 11 | 1 | 0.57s | 0.10s | **0.18x** | coordinate shift vs expanded grid |
| 11 | 2 | 0.58s | 0.10s | **0.18x** | same |
| 12 | 1 | 0.11s | 0.19s | 1.68x |  |
| 12 | 2 | 2.06s | 3.93s | 1.90x | same approach both sides |
| 13 | 1 | 0.041s | 0.054s | 1.32x |  |
| 13 | 2 | 0.044s | 0.055s | 1.25x |  |
| 14 | 1 | 0.038s | 0.027s | 0.71x |  |
| 14 | 2 | 0.97s | 2.81s | **2.88x** | same approach both sides |
| 15 | 1 | 0.041s | 0.024s | 0.59x |  |
| 15 | 2 | 0.046s | 0.040s | 0.87x |  |
| 16 | 1 | 0.056s | 0.068s | 1.21x |  |
| 16 | 2 | 3.69s | 9.88s | **2.68x** | same approach both sides |
| 17 | 1 | 99.48s | 0.69s | **0.01x** | collapsed state space + bucket queue vs A* over full state |
| 17 | 2 | 482.95s | 1.61s | **0.00x** | same; Ruby also renders a grid |
| 18 | 1 | 0.038s | 0.020s | 0.53x |  |
| 18 | 2 | 0.036s | 0.031s | 0.86x |  |
| 19 | 1 | 0.039s | 0.025s | 0.64x |  |
| 19 | 2 | 0.037s | 0.025s | 0.68x |  |
| 20 | 1 | 0.077s | 0.13s | 1.70x |  |
| 20 | 2 | 0.19s | 0.40s | 2.10x |  |
| 21 | 1 | 9.52s | 0.081s | **0.01x** | parity BFS vs A*; Ruby also renders a grid |
| 21 | 2 | — | 4.27s | — | no Ruby version |
| 22 | 1 | — | 0.040s | — | no Ruby version |

### Where Sigil wins, and why it is not a language win

Days 10p2, 11, 17 and 21 are the divergent ones, and every one of them is my algorithm being cheaper
rather than Sigil being faster:

- **Day 17 — 99s vs 0.75s (part 1) and 483s vs 1.7s (part 2).** The Ruby is a general A* over
  `(position, direction, run length)` using the `pqueue` gem; the Sigil collapses the state to
  `(position, axis)` with whole runs as edges, which is ~6x fewer states, and uses a bucket queue.
  Both also print differently — the Ruby renders a colourised grid of the path, which is real I/O.
- **Day 21 part 1 — 9.5s vs 0.13s.** Same story: A* where a parity BFS suffices.
- **Day 10 part 2 — 0.30s vs 0.10s.** Shoelace and Pick's theorem against a flood fill.
- **Day 11 — 0.57s vs 0.15s.** Shifting coordinates against building the expanded grid.

Had I read the Ruby first and matched its approach, these rows would look like the others.

### Where Sigil loses worst

These three rows were the ones worth attacking, and all three were attacked. What each turned out to
be is not what the row looked like.

- **Day 14 part 2 — 0.97s vs 2.71s, 2.88x.** Still the worst honest row, but down from 3.50x. ~140
  spin cycles, each rebuilding the grid as strings. It looked like a string-*building* cost and it
  was mostly a string-*reading* one: `Str.chars` allocated a fresh heap block per character and
  `Str.slice` walked to its bounds from the front, which made the transpose quadratic in the row
  width. Fixed in [D-100](../../personal/sigil/DECISIONS.md); **3.33s → 2.71s** on the same program.
  What is left is not strings at all — after the fix the profile is 26% VM dispatch and 30% `Value`
  clone and drop, which is interpreter overhead and a different piece of work.
- **Day 8 part 2 — 0.049s vs 0.107s, 2.18x.** Correctly diagnosed here as a ratio of two startup
  costs, and that is what got fixed: `sigil exec` was spending 47ms of its 54ms floor installing the
  standard library into a store it would delete seconds later
  ([D-101](../../personal/sigil/DECISIONS.md)). The floor is now ~0.018s and this row went
  **0.159s → 0.107s**. Every short row in the table moved with it, which is why the median flipped.
- **Day 16 part 2 — 3.69s vs 9.85s, 2.68x.** Down from 4.46x on the `Map` fix alone. **The claim
  that this row is the best argument for Draft B did not survive being profiled.** A `Set[K]` would
  replace `Map[K, Bool]`, and the `Bool` it removes is stored *inline* in the entry — 24 bytes, no
  allocation, no refcount — so the time it saves is close to nothing. The profile agrees: map
  operations and the comparisons under them are ~11-15% of this program, while **VM dispatch plus
  `Value` clone and drop are ~56%**. Draft B is still worth having for what it says — `Map.insert(seen,
  state, true)` does not read as set membership — but it should be argued on that, because the
  performance argument this row was supposed to supply is not there.

### Caveats

- Best of three runs per cell (best of one above ~2s), foreground, stdout to a pipe, through a
  harness that raises rather than reports a time if the run exits non-zero or prints nothing.
  Differences under ~15% here are still noise.
- Ruby was run without YJIT. Enabling it would widen most gaps.
- Days 17 and 21 needed the `pqueue` gem installed into the mise Ruby 3.3.0 to run at all; that gem
  requirement is itself an argument for `STDLIB-PROPOSALS.md` Draft J, since the Sigil version had to
  hand-roll the priority queue that Ruby installed from a package.
- Days 22-25 have no Sigil implementation yet; days 21p2, 24p2 and 25p2 have no Ruby one.
- The Ruby column re-measured within a few percent of the original table everywhere except day 10
  part 2 (0.30s now against 0.86s then), which renders a grid and was probably first measured with
  its output going to a terminal rather than a pipe.

## Sigil timings alone, for reference

Every program on its real input, on the fixed build. Slowest first, with what the same program cost
before this session's four changes.

| day | part | was | now | what it is |
|---|---|---|---|---|
| 16 | 2 | 16.23s | **9.89s** | 440 separate beam walks |
| 21 | 2 | 6.79s | **4.27s** | three BFS sweeps over a wrapping grid, then extrapolation |
| 12 | 2 | 3.90s | 3.93s | DP over ~1000 unfolded records — a `List` of rows, so unaffected |
| 14 | 2 | 3.33s | **2.81s** | ~140 spin cycles until the loop is found |
| 17 | 2 | 2.06s | **1.61s** | Dijkstra, ~40000 states |
| 17 | 1 | 0.97s | **0.69s** | same |
| 20 | 2 | 0.47s | **0.40s** | ~4100 button presses |
| 12 | 1 | 0.23s | **0.19s** | the same DP, not unfolded |

**35 of the 43 now finish in under 0.15s**, and for those the number is mostly process startup:
~0.018s of floor against ~0.035s for Ruby. The corpus total went from 38.0s to **25.4s**.

Two things that number hides, in opposite directions.

It **understates** the fix, because every one of these programs was written around the old costs.
Day 12's DP table is a `List` of rows because a `Map` was too slow; days 16, 17 and 21 bucket their
maps by grid row for the same reason; day 21 hand-rolled a dedupe because `uniq` was quadratic. All
of those workarounds are still in place, and the bucketing is now a small loss rather than a 10x
win. What the fixes bought is not visible in the programs that avoided the problem.

It **overstates** it for the short rows, because a program that finishes in 20ms has not been made
fast — a store it was going to throw away has stopped being built from scratch. The only rows that
say anything about the language are the ones at the top of this table, and there the honest summary
is: `Map` and `uniq` were asymptotic bugs and are fixed; strings were allocating far too much and
are better; and what is left is the interpreter itself, which is roughly half of every heavy
program's time and has not been touched.

## Refactor pass, 2026-07-31 — and a build-mismatch warning

A full review-and-refactor pass over all 43 programs (one agent per day, outputs verified
byte-identical against a pre-refactor baseline). Perf movement on the real inputs, foreground,
same machine: day 12 part 2 **4.05s → 1.62s** (per-record run table replaces per-cell scans),
day 14 part 2 **3.53s → 1.96s** (dropped the mirror trick for a direct east pack; `seen ++ [rows]`
→ `push`), day 16 part 2 **16.6s → 9.4s** (beams slide across runs of empty tiles, so only mirror
arrivals enter the visited set). Everything else within noise. Line counts mostly down a little;
day 16 grew ~50 lines per file to buy its 1.86x.

### The warning: the `sigil` on PATH is not the build the re-measurements above describe

Every "fixed" claim in this document was re-measured on a dev build. The installed `sigil 0.1.0`
that actually runs these programs still has the old behaviour — measured directly this session:

- `Map.insert` fold: 16000 → 1.66s, 48000 → 16.2s. That is the **"was"** row, exactly. The
  bucketed-map workarounds (days 16, 17, 21) are still load-bearing: de-bucketing day 17 was tried
  and went 1.0s → 24s; day 16 went 0.17s → 2.17s on part 1. Both reverted.
- `List.uniq` is still O(n × distinct): 80k records took 14.8s (day 21 probe).
- `Set`, `Int.rem_euclid`, `Int.parse_radix` do not exist — E0402. The stdlib reference site
  documents them; the binary does not have them.

So: either install the fixed build on PATH, or read this document's "now" rows as "not yet, here".

### New language findings from the pass (installed 0.1.0)

- **No list patterns.** `[a, b, c]` as a pattern is E0115 — `get(i)`/`ok_or` chains stay.
- **String-literal `match` arms work**, including a trailing bare-identifier catch-all that binds
  the value (used for colour names, pipe shapes).
- **Match arms cannot share a line comma-separated** (E0110); one arm per line.
- **`_` is not a legal closure parameter name** — use a real name.
- **`List.sort` requires a comparator** (E0204 if called bare); `List.sorted` is the natural-order one.
- **Type aliases must be records/sums.** `type Part = Map[Str, Int]` and parameterized RHSes are
  E0112 — long map signatures get written out in full.
- **`sigil exec` sandboxes fs reads to the script's directory** — a temp copy of a program must
  bring its input along.
