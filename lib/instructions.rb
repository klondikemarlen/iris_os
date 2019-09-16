# frozen_string_literal: true

require 'operators'

module Instructions
  module Ops
    include Operators::Types
  end

  module Types
    R8_IMM8 = lambda do |ctx|
      return false unless ctx.count == 2
      return false unless Ops::IMM8.call ctx.op2

      Ops::R8.call ctx.op1
    end
  end

  class << self
    include Enumerable

    def each(&block)
      Types.constants.each do |symbol|
        block.call(symbol, Types.const_get(symbol))
      end
    end
  end
end

class Instruction
  attr_reader :name, :operators

  ##
  # Fail fast is purely for testing.
  # Perhaps a better technique would be to fix the tests ...
  def initialize(mnemonic, *operators, fast_fail: true)
    @name = mnemonic
    @operators = operators
    define_opx_for_each_operator
    @type = determine_type if fast_fail
  end

  def count
    operators.length
  end

  def type
    @type ||= determine_type
  end

  #######
  private
  #######

  def determine_type
    local_type = nil
    Instructions.each do |label, matcher|
      local_type = matcher.call(self) && label.downcase
      break unless local_type.nil?
    end

    unless local_type
      raise ArgumentError,
            "No type matcher for operators: #{operators}."
    end

    local_type
  end

  def define_opx_for_each_operator
    operators.each.with_index(1) do |op, i|
      define_singleton_method("op#{i}".intern) do
        type_cast(op)
      end
    end
  end

  def type_cast(operator)
    return operator if operator.is_a?(Register) || operator.is_a?(Immediate)

    if operator.is_a?(Integer) || operator.is_a?(String)
      return Immediate.new(operator)
    end

    raise ArgumentError, "No type match for operator class #{operator.class}."
  end
end
