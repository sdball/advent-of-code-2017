class Captcha
  def self.solve(input)
    list = splitInput(input)
    result = 0
    list.each_with_index do |item, index|
      next_item = list[(index + list.length / 2) % list.length]
      result += item if (item == next_item)
    end
    result
  end

  def self.splitInput(input)
    String(input).split("").map { |e| Integer(e) }
  end
end

def expect(result, expected)
  raise "#{result.inspect} does not equal #{expected.inspect}" if result != expected
end

# the list contains 4 items, and all four digits match the digit 2 items ahead
expect(Captcha.solve(1212), 6)

# every comparison is between a 1 and a 2
expect(Captcha.solve(1221), 0)

# both 2s match each other, but no other digit has a match
expect(Captcha.solve(123425), 4)

expect(Captcha.solve(123123), 12)

expect(Captcha.solve(12131415), 4)

puts Captcha.solve(ARGV.first)
