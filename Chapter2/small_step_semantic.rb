class SmallStepSemantic
end
class Number < Struct.new(:value)
  def inspect
    "<<#{self}>>"
  end

  def to_s
    value.to_s
  end

  def reducible?
    false
  end
end

class Add<Struct.new(:left, :right)
  def to_s
    "#{left}+#{right}"
  end

  def inspect
    "<<#{self}>>"
  end

  def reducible?
    true
  end

  def reduce
    if left.reducible?
      Add.new(left.reduce, right)
    elsif right.reducible?
      Add.new(left, right.reduce)
    else
      Number.new(left.value+right.value)
    end
  end
end

class Multiply<Struct.new(:left, :right)
  def to_s
    "#{left}*#{right}"
  end

  def inspect
    "<<#{self}>>"
  end

  def reducible?
    true
  end

  def reduce
    if left.reducible?
      Add.new(left.reduce, right)
    elsif right.reducible?
      Add.new(left, right.reduce)
    else
      Number.new(left.value*right.value)
    end
  end
end

class Machine<Struct.new(:expression)
  public
  def run
    puts expression
    while expression.reducible?
      self.expression=expression.reduce
      puts expression
    end
  end
end

res= Add.new(Multiply.new(Number.new(2), Number.new(3)), Multiply.new(Number.new(2), Number.new(3)))

puts Machine.new(res).run
