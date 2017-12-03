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

  def parse(text)
    text ||= ""
    text.split("\n").each do |row|
      @rows << row.split(/\s+/).map(&:to_i)
    end
    self
  end
end

# For each row, determine the difference between the largest value and the
# smallest value; the checksum is the sum of all of these differences.
s = Sheet.new
s.addRow [5, 1, 9, 5]
s.addRow [7, 5, 3]
s.addRow [2, 4, 6, 8]
expect(s.checksum, 18)

expect(Sheet.new.parse("5 1 9 5\n7 5 3\n2 4 6 8").rows, [[5, 1, 9, 5], [7, 5, 3], [2, 4, 6, 8]])

expect(Sheet.new.parse("5 1 9 5\n7 5 3\n2 4 6 8").checksum, 18)

expect(Sheet.new.parse("5 1 9 5").checksum, 8)

puts Sheet.new.parse(File.read(ARGV.first)).checksum
