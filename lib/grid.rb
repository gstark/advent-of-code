class Grid
  include Enumerable

  attr_reader :width, :height

  NEIGHBOR_DELTAS = (-1..1).flat_map { |dr| (-1..1).map { |dc| [dr, dc] } } - [[0, 0]]

  def initialize(input, wrap: false)
    @data = input.split("\n").map(&:chars)
    @height = @data.length
    @width = @data.first&.length || 0
    @wrap = wrap
  end

  def [](row, col)
    return nil unless valid?(row, col)

    @data[row][col]
  end

  def []=(row, col, value)
    return unless valid?(row, col)

    @data[row][col] = value
  end

  def each
    return to_enum(:each) unless block_given?

    @data.each_with_index do |row_data, row|
      row_data.each_with_index do |value, col|
        yield row, col, value
      end
    end
  end

  def neighbors(row, col)
    NEIGHBOR_DELTAS.each_with_object({}) do |(dr, dc), hash|
      nr, nc = neighbor_coords(row, col, dr, dc)
      next if nr.nil?

      hash[direction_key(dr, dc)] = @data[nr][nc]
    end
  end

  def dup
    super.tap do |new_grid|
      new_grid.instance_variable_set(:@data, @data.map(&:dup))
    end
  end

  def to_s
    @data.map(&:join).join("\n")
  end

  private

  def valid?(row, col)
    if @wrap
      true
    else
      row >= 0 && row < @height && col >= 0 && col < @width
    end
  end

  def neighbor_coords(row, col, dr, dc)
    nr = row + dr
    nc = col + dc

    if @wrap
      nr %= @height
      nc %= @width

      [nr, nc]
    elsif nr >= 0 && nr < @height && nc >= 0 && nc < @width
      [nr, nc]
    end
  end

  def direction_key(dr, dc)
    case [dr, dc]
    when [-1, -1] then :nw
    when [-1, 0] then :n
    when [-1, 1] then :ne
    when [0, -1] then :w
    when [0, 1] then :e
    when [1, -1] then :sw
    when [1, 0] then :s
    when [1, 1] then :se
    end
  end
end
