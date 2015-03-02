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

  def reduce(environment)
    if left.reducible?
      Add.new(left.reduce(environment), right)
    elsif right.reducible?
      Add.new(left, right.reduce(environment))
    else
      Number.new(left.value+right.value)
    end
  end
end

class Minus<Struct.new(:left, :right)
  def to_s
    "#{left}-#{right}"
  end

  def inspect
    "<<#{self}>>"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      Add.new(left.reduce(environment), right)
    elsif right.reducible?
      Add.new(left, right.reduce(environment))
    else
      Number.new(left.value-right.value)
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

  def reduce(environment)
    if left.reducible?
      Add.new(left.reduce(environment), right)
    elsif right.reducible?
      Add.new(left, right.reduce(environment))
    else
      Number.new(left.value*right.value)
    end
  end
end

class Divide<Struct.new(:left, :right)
  def to_s
    "#{left}/#{right}"
  end

  def inspect
    "<<#{self}>>"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      Add.new(left.reduce(environment), right)
    elsif right.reducible?
      Add.new(left, right.reduce(environment))
    else
      Number.new(left.value/right.value)
    end
  end
end

class Boolean<Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "<<#{self}>>"
  end

  def reducible?
    false
  end

end

class LessThan<Struct.new(:left,:right)
  def to_s
    "#{left}<#{right}"
  end

  def inspect
    "<<#{self}>>"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      LessThan.new(left.reduce(environment),right)
    elsif right.reducible?
      LessThan.new(left,right.reduce(environment))
    else
      Boolean.new(left.value<right.value)
    end
  end
end

class Variable<Struct.new(:name)
  def to_s
    name.to_s
  end

  def inspect
    "<<#{self}>>"
  end

  def reducible?
    true
  end

  def reduce(environment)
    environment[name]
  end
end

class Machine<Struct.new(:expression,:environment)
  def step
    self.expression=expression.reduce(environment)
  end
  public
  def run
    while expression.reducible?
      puts expression
      step
    end
    puts expression
  end
end

res= Add.new(Multiply.new(Number.new(2), Number.new(3)), Multiply.new(Number.new(2), Number.new(3)))

puts Machine.new(res).run

expression = LessThan.new(Minus.new(Number.new(9),Number.new(5)),Multiply.new(Number.new(2),Number.new(3)))
puts Machine.new(expression).run

expressionWithVariables = LessThan.new(Variable.new(:x),Variable.new(:y))
puts Machine.new(expressionWithVariables,{x:Number.new(7),y:Number.new(4)}).run