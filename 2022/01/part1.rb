p ARGF.readlines.map(&:to_i).chunk_while { _2.nonzero? }.map(&:sum).max
