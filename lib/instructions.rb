# frozen_string_literal: true

require 'operators'

module Instructions
  module Types
    include Operators::Types # not sure if this is a good idea ..

    R8_IMM8 = lambda do |ctx|
      return false unless ctx.count == 2
      return false unless IMM8.call ctx.op2

      R8.call ctx.op1
    end
  end
end

class Instruction
  attr_reader :name, :operators

  def initialize(mnemonic, *operators)
    @name = mnemonic
    @operators = operators
    define_opx_for_each_operator
  end

  def count
    operators.length
  end

  def define_opx_for_each_operator
    operators.each.with_index(1) do |op, i|
      instance_variable_set "@op#{i}", op
      self.class.send :attr_reader, "op#{i}".intern
    end
  end

  def type
    @type || ContextTypes.constants.each do |type|
      result = type.call(self)
      if result
        @type = type.downcase
        break
      end
    end
  end
end
