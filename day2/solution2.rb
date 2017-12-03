def expect(result, expected)
  raise "#{result.inspect} does not equal #{expected.inspect}" if result != expected
end

class Sheet
  def initialize
    @rows = []
  end

  def addRow(arr)
    @rows << arr
  end

  def rows
    @rows
  end

  def checksum
    @rows.reduce(0) do |acc, row|
      acc + (row.max - row.min)
    end
  end

  def evenlyDivisibleValues
    @rows.map { |row| Calculator.determineEvenlyDivisibleValues(row) }
  end

  def userCalculation
    Calculator.sum(Calculator.dividePairs(evenlyDivisibleValues))
  end

  def parse(text)
    text ||= ""
    text.split("\n").each do |row|
      @rows << row.split(/\s+/).map(&:to_i)
    end
    self
  end
end

class Calculator
  def self.dividePairs(list)
    list.map do |pair|
      pair.max / pair.min
    end
  end

  def self.determineEvenlyDivisibleValues(list)
    list.each_with_index do |a, i1|
      list.each_with_index do |b, i2|
        return [a,b].sort.reverse if a.remainder(b).zero? && i1 != i2
      end
    end
  end

  def self.sum(list)
    list.reduce(&:+)
  end
end

expect(Calculator.dividePairs([[10,5], [70, 10]]), [2,7])
expect(Calculator.determineEvenlyDivisibleValues([2,3,4]), [4,2])
expect(Calculator.determineEvenlyDivisibleValues([3,13,7,70]), [70,7])

# find the only two numbers in each row where one evenly divides the other -
# that is, where the result of the division operation is a whole number. They
# would like you to find those numbers on each line, divide them, and add up
# each line's result
testSheet = Sheet.new.parse("5 9 2 8\n9 4 7 3\n3 8 6 5")
expect(testSheet.evenlyDivisibleValues, [[8,2], [9,3], [6,3]])
expect(testSheet.userCalculation, 9)

puts Sheet.new.parse(File.read(ARGV.first)).userCalculation if ARGV.first

