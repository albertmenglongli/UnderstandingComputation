multiply = -> x, y { x*y }
puts multiply.call(3, 5)
puts multiply[2, 4]

fruits={a: 'apple', b: 'banana'}
puts fruits[:b]

def join_with_commas(*words)
  words.join(',')
end

puts join_with_commas('Tom', 'Jim', 'Steve')

before, *words, after=['Very beginning', 'there is', 'one', 'big dragon', '.']
puts join_with_commas(*words)

def do_three_times
  yield('Tom')
  yield('Jim')
  yield('Bob')
end

do_three_times { |n| puts "#{n}, nice to meet you" }

numbers_mul_3=(1..3).map { |n| n*3 }
puts numbers_mul_3

class Point <Struct.new(:x,:y)
  def inspect
    "#<Point #{x},#{y}>"
  end
end
p=Point.new(2,3)
puts p
puts Point.new(2,4)==Point.new(2,4)

NUMBERS=(1..3)
puts NUMBERS.size
Object.send(:remove_const,:NUMBERS)
NUMBERS=4
puts NUMBERS