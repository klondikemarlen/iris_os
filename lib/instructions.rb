# frozen_string_literal: true

require_relative 'immediates'
require_relative 'operators'
require_relative 'registers'
require_relative 'labels'

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
    self.operators = operators
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

  def cast_to_assembly_types(operator)
    return operator if no_cast_needed?(operator)
    return Immediate.new(operator) if immediate_equivalent?(operator)
    return operator.to_imm if operator.is_a?(Label)

    raise ArgumentError, "No type match for operator class #{operator.class}."
  end

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

  def immediate_equivalent?(operator)
    [Integer, String].any? { |klass| operator.is_a?(klass) }
  end

  def no_cast_needed?(operator)
    [Register, Immediate].any? { |klass| operator.is_a?(klass) }
  end

  def operators=(ops)
    @operators = ops

    operators.each.with_index(1) do |op, i|
      define_singleton_method("op#{i}".intern) { cast_to_assembly_types(op) }
    end
  end
end
