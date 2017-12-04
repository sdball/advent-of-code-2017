def expect(result, expected)
  raise "#{result.inspect} does not equal #{expected.inspect}" if result != expected
end

# Each square on the grid is allocated in a spiral pattern starting at a location marked 1 and then counting up while spiraling outward. For example, the first few squares are allocated like this:

# 17  16  15  14  13

# 18   5   4   3  12
#
# 19   6   1   2  11
#
# 20   7   8   9  10
#
# 21  22  23---> ...

# While this is very space-efficient (no squares are skipped), requested data
# must be carried back to square 1 (the location of the only access port for this
# memory system) by programs that can only move up, down, left, or right. They
# always take the shortest path: the Manhattan Distance between the location of
# the data and square 1.

class SpiralMemory
# START at ODD square above N (e.g. 27 -> 49, 37 -> 49)
# work backwards to end iterating from CYCLE MAX to CYCLE MIN to CYCLE MAX to CYCLE MIN
  def self.steps(position)
    return 0 if position == 1
    cycle_max = cycle_max(position)
    cycle_min = cycle_min(position)
    steps = cycle_max
    cycle_direction = :down
    (odd_square_above(position)).downto(position) do |n|
      return steps if n == position
      case cycle_direction
      when :down
        steps -= 1
        if steps == cycle_min
          cycle_direction = :up
        end
      when :up
        steps += 1
        if steps == cycle_max
          cycle_direction = :down
        end
      end
    end
    steps
  end

  def self.odd_square_below(position)
    previousSquareRoot = Math.sqrt(position).floor
    if previousSquareRoot.odd?
      previousSquareRoot ** 2
    else
      (previousSquareRoot - 1) ** 2
    end
  end

  def self.odd_square_above(position)
    nextSquareRoot = Math.sqrt(position).ceil
    if nextSquareRoot.odd?
      nextSquareRoot ** 2
    else
      (nextSquareRoot + 1) ** 2
    end
  end

  def self.odd_square_steps_to_origin(odd_square)
    if odd_square.even? || Math.sqrt(odd_square).floor ** 2 != odd_square
      raise ArgumentError("#{odd_square} is not an odd square")
    end

    Math.sqrt(odd_square) - 1
  end

  def self.cycle_max(position)
    odd_square_steps_to_origin(odd_square_below(position)) + 2
  end

  def self.cycle_min(position)
    cycle_max(position) / 2
  end
end

# pull out the square below N
# CYCLE MAX is two higher than the distance of the ODD square below N
# SQUARE DISTANCE TO 1 is (square).sqrt - 1, e.g. 25 -> 4
# CYCLE MIN is CYCLE MAX/2
# CYCLE ends at ODD square below N (e.g. 27 -> 25, 37 -> 25)
# START at ODD square above N (e.g. 27 -> 49, 37 -> 49)
# work backwards to end iterating from CYCLE MAX to CYCLE MIN to CYCLE MAX to CYCLE MIN
# 49 (6), 48 (5), 47 (4), 46 (3), 45 (4), 44 (5), 43 (6)

expect(SpiralMemory.odd_square_below(25), 25)
expect(SpiralMemory.odd_square_below(27), 25)
expect(SpiralMemory.odd_square_below(37), 25)
expect(SpiralMemory.odd_square_below(49), 49)

expect(SpiralMemory.odd_square_above(25), 25)
expect(SpiralMemory.odd_square_above(27), 49)
expect(SpiralMemory.odd_square_above(37), 49)
expect(SpiralMemory.odd_square_above(49), 49)

expect(SpiralMemory.odd_square_steps_to_origin(1), 0)
expect(SpiralMemory.odd_square_steps_to_origin(9), 2)
expect(SpiralMemory.odd_square_steps_to_origin(25), 4)
expect(SpiralMemory.odd_square_steps_to_origin(49), 6)
expect(SpiralMemory.odd_square_steps_to_origin(81), 8)

expect(SpiralMemory.cycle_max(4), 2)
expect(SpiralMemory.cycle_max(10), 4)
expect(SpiralMemory.cycle_max(27), 6)
expect(SpiralMemory.cycle_max(45), 6)
expect(SpiralMemory.cycle_max(57), 8)

expect(SpiralMemory.cycle_min(4), 1)
expect(SpiralMemory.cycle_min(10), 2)
expect(SpiralMemory.cycle_min(27), 3)
expect(SpiralMemory.cycle_min(45), 3)
expect(SpiralMemory.cycle_min(57), 4)

# it's at the access port
expect(SpiralMemory.steps(1), 0)

# such as: down, left, left
expect(SpiralMemory.steps(12), 3)

# up, up
expect(SpiralMemory.steps(23), 2)

expect(SpiralMemory.steps(1024), 31)

PUZZLE_INPUT=347991
puts SpiralMemory.steps(PUZZLE_INPUT)

