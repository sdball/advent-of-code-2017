class Captcha
  def self.solve(input)
    list = splitInput(input)
    result = 0
    list.each_with_index do |item, index|
      next_item = list[(index + 1) % list.length]
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

# because the first digit (1) matches the second digit
# and the third digit (2) matches the fourth digit
expect(Captcha.solve(1122), 3)

# because each digit (all 1) matches the next
expect(Captcha.solve(1111), 4)

# because no digit matches the next
expect(Captcha.solve(1234), 0)

# because the only digit that matches the next one is the last digit, 9
expect(Captcha.solve(91212129), 9)

puts Captcha.solve(ARGV.first)
