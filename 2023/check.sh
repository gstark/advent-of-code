#!/bin/bash
#
# Everything the Sigil half of this corpus claims, checked in one command.
#
#   bash ~/dev/advent-of-code/2023/check.sh
#
# The real inputs are gitignored at AoC's own request, so CI cannot hold the
# programs to their real answers. What it can hold them to is the samples,
# which are published in every puzzle text: each program runs against every
# sample it is known to handle, and the exact stdout is recorded beside it in
# expected/. A program whose samples cannot drive it — day 20 part 2 needs the
# real input's rx wiring, day 21 part 2 its grid geometry — is held to the
# type checker instead, which is the check that catches a language change.
#
# Re-record after an intentional output change with:
#
#   BLESS=1 bash check.sh
#
# then read the diff — a vanished expected/ file means a program stopped
# passing on a sample, which bless will not say out loud.

set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SIGIL="${SIGIL:-sigil}"

# A shared scratch store for the check-only programs, so the standard library
# installs once instead of once per program. Deleted on the way out.
SCRATCH="$(mktemp -d)"
trap 'rm -rf "${SCRATCH}"' EXIT

# macOS has no `timeout`; perl's alarm is everywhere. A sample that takes
# longer than this is a hang, not a slow answer — the whole corpus of real
# inputs runs in under half a minute.
run_limited() {
  perl -e 'alarm 30; exec @ARGV' "$@"
}

ran=0
checked=0
failures=()

for prog in "${DIR}"/*/part*.sg; do
  day_dir="$(dirname "${prog}")"
  base="$(basename "${prog}" .sg)"
  label="$(basename "${day_dir}")/${base}"

  if [ "${BLESS:-0}" = "1" ]; then
    rm -f "${day_dir}/expected/${base}-"*.out
    for sample in "${day_dir}"/sample*.txt; do
      stem="$(basename "${sample}" .txt)"
      if out="$(cd "${day_dir}" && run_limited "${SIGIL}" exec "${base}.sg" -- "${stem}.txt" 2>/dev/null)"; then
        mkdir -p "${day_dir}/expected"
        printf '%s\n' "${out}" > "${day_dir}/expected/${base}-${stem}.out"
        echo "blessed ${label} on ${stem}.txt"
      fi
    done
    continue
  fi

  expected=("${day_dir}/expected/${base}-"*.out)
  if [ ! -e "${expected[0]}" ]; then
    # No sample can drive this program; the type checker still has a say.
    if ! out="$(cd "${day_dir}" && "${SIGIL}" --store "${SCRATCH}/check.db" check "${base}.sg" 2>&1)"; then
      failures+=("${label}: does not check:"$'\n'"${out}")
    fi
    checked=$((checked + 1))
    continue
  fi

  for exp in "${expected[@]}"; do
    stem="$(basename "${exp}" .out)"
    stem="${stem#"${base}"-}"
    got="$(cd "${day_dir}" && run_limited "${SIGIL}" exec "${base}.sg" -- "${stem}.txt" 2>&1)"
    code=$?
    want="$(cat "${exp}")"
    if [ "${code}" -ne 0 ] || [ "${got}" != "${want}" ]; then
      failures+=("${label} on ${stem}.txt (exit ${code}):"$'\n'"  wanted: ${want}"$'\n'"  got:    ${got}")
    fi
    ran=$((ran + 1))
  done
done

if [ "${BLESS:-0}" = "1" ]; then
  echo "done — read the diff before committing it"
  exit 0
fi

echo
echo "ran ${ran} recorded sample runs, type-checked ${checked} programs no sample can drive"
if [ "${#failures[@]}" -gt 0 ]; then
  echo "FAILURES (${#failures[@]}):"
  for failure in "${failures[@]}"; do
    echo "- ${failure}"
  done
  exit 1
fi
echo "all held"
