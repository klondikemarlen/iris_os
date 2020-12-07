# frozen_string_literal: true

require_relative 'asm_error'
require_relative 'effective_address'
require_relative 'hexable'
require_relative 'operators'
require_relative 'registers'

class MoveInstruction
  module InstructionOperands
    REGISTER_8_BIT = ->(operand) { operand.is_a?(Register) && operand.width == 8 }
    IMMEDIATE_8_BIT = ->(operand) { operand.is_a?(Immediate) && operand.width == 8 }

    REGISTER_AL = ->(operand) { operand.is_a?(Register) && operand.name == :al }
    MEMORY_OFFSET_8_BIT = lambda do |operand|
      operand.is_a?(EffectiveAddress) && operand.width == 8
    end
  end

  module InstructionCombinations
    REGISTER_8_BIT_AND_IMMEDIATE_8_BIT = lambda do |ctx|
      return false unless InstructionOperands::IMMEDIATE_8_BIT.call ctx.operand2

      InstructionOperands::REGISTER_8_BIT.call ctx.operand1
    end

    # MOV AL, moffs8
    REGISTER_AL_MEMORY_OFFSET_8_BIT = lambda do |ctx|
      return false unless InstructionOperands::MEMORY_OFFSET_8_BIT.call ctx.operand2

      InstructionOperands::REGISTER_AL.call ctx.operand1
    end
  end

  class << self
    def parse(operand)
      return Immediate.new(operand) if immediate_equivalent?(operand)
      return operand.to_imm if operand.is_a?(Label)
      return EffectiveAddress.new(operand) if operand.is_a?(Array)

      raise ArgumentError, "No type match for source class #{operand.class}."
    end

    def immediate_equivalent?(operand)
      [Integer, String].any? { |klass| operand.is_a?(klass) }
    end
  end

  class MoveInstructionError < AsmError; end
  class UnknownPrimaryOpCodeError < MoveInstructionError; end

  using Hexable

  attr_reader :operand1, :operand2

  def initialize(operand1, operand2)
    @operand1 = operand1
    @operand2 = operand2
  end

  def primary_opcode
    @primary_opcode ||= \
      case self
      when InstructionCombinations::REGISTER_AL_MEMORY_OFFSET_8_BIT
        0xA0
      when InstructionCombinations::REGISTER_8_BIT_AND_IMMEDIATE_8_BIT
        register = operand1
        0xb0 + register.extension
      else
        raise UnknownPrimaryOpCodeError,
              "Can't determine primary opcode given #{operand1}, #{operand2}."
      end
  end

  def to_s
    "#{primary_opcode}#{operand2}"
  end
end

module MoveInstructions
  include Registers

  # B0+ rb  MOV r8,imm8   Move imm8 to r8.
  def mov(destination, source)
    parsed_source = MoveInstruction.parse(source)
    @instructions << MoveInstruction.new(destination, parsed_source).to_s
  end
end
