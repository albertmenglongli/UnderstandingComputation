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

class LessThan<Struct.new(:left, :right)
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
      LessThan.new(left.reduce(environment), right)
    elsif right.reducible?
      LessThan.new(left, right.reduce(environment))
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

class Machine<Struct.new(:expression, :environment)
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

class DoNothing
  def to_s
    'do-nothing'
  end

  def inspect
    "<<#{self}>>"
  end

  def ==(other_statement)
    other_statement.instance_of?(DoNothing)
  end

  def reducible?
    false
  end
end

class Assign <Struct.new(:name, :expression)
  def to_s
    "#{name}=#{expression}"
  end

  def inspect
    "<<#{self}>>"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if expression.reducible?
      [Assign.new(name, expression.reduce(environment)), environment]
    else
      [DoNothing.new, environment.merge({name => expression})]
    end
  end
end

class If<Struct.new(:condition, :consequence, :alternative)
  def to_s
    "if (#{condition}) { #{consequence} } else { #{alternative} }"
  end

  def inspect
    "<<#{self}>>"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if condition.reducible?
      [If.new(condition.reduce(environment), consequence, alternative), environment]
    else
      case condition
        when Boolean.new(true)
          [consequence, environment]
        when Boolean.new(false)
          [alternative, environment]
      end
    end
  end
end

res= Add.new(Multiply.new(Number.new(2), Number.new(3)), Multiply.new(Number.new(2), Number.new(3)))

puts Machine.new(res).run

expression = LessThan.new(Minus.new(Number.new(9), Number.new(5)), Multiply.new(Number.new(2), Number.new(3)))
puts Machine.new(expression).run

expressionWithVariables = LessThan.new(Variable.new(:x), Variable.new(:y))
puts Machine.new(expressionWithVariables, {x: Number.new(7), y: Number.new(4)}).run


Object.send(:remove_const, :Machine)
class Machine<Struct.new(:statement, :environment)
  def step
    self.statement, self.environment=statement.reduce(environment)
  end

  def run
    while statement.reducible?
      puts "#{statement},#{environment}"
      step
    end
    puts "#{statement},#{environment}"
  end

end
assignStatement = Assign.new(:x, Add.new(Variable.new(:x), Number.new(3)))
env={x: Number.new(5)}
Machine.new(assignStatement, env).run

Machine.new(If.new(LessThan.new(Number.new(2), Number.new(3)), Assign.new(Variable.new(:x), Number.new(2)),
                   Assign.new(Variable.new(:x), Number.new(3))), {x: Number.new(1)}).run