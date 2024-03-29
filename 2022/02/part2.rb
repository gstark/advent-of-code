guide = ARGF.readlines.map(&:split)

ROCK_VALUE = 1
PAPER_VALUE = 2
SCISSORS_VALUE = 3

LOSS_POINTS = 0
TIE_POINTS = 3
WIN_POINTS = 6

OPPONENT_ROCK = "A"
OPPONENT_PAPER = "B"
OPPONENT_SCISSORS = "C"

NEED_LOSS = "X"
NEED_TIE = "Y"
NEED_WIN = "Z"

GUIDE_TO_VALUE_LOOKUP = {
  [OPPONENT_ROCK, NEED_WIN] => WIN_POINTS + PAPER_VALUE,
  [OPPONENT_ROCK, NEED_LOSS] => LOSS_POINTS + SCISSORS_VALUE,
  [OPPONENT_ROCK, NEED_TIE] => TIE_POINTS + ROCK_VALUE,
  [OPPONENT_PAPER, NEED_WIN] => WIN_POINTS + SCISSORS_VALUE,
  [OPPONENT_PAPER, NEED_LOSS] => LOSS_POINTS + ROCK_VALUE,
  [OPPONENT_PAPER, NEED_TIE] => TIE_POINTS + PAPER_VALUE,
  [OPPONENT_SCISSORS, NEED_WIN] => WIN_POINTS + ROCK_VALUE,
  [OPPONENT_SCISSORS, NEED_LOSS] => LOSS_POINTS + PAPER_VALUE,
  [OPPONENT_SCISSORS, NEED_TIE] => TIE_POINTS + SCISSORS_VALUE
}

p guide.sum { |entry| GUIDE_TO_VALUE_LOOKUP[entry] }
