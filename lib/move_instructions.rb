# frozen_string_literal: true

require_relative 'asm_error'
require_relative 'effective_address'
require_relative 'hexable'
require_relative 'operators'
require_relative 'registers'

class MoveInstruction
  module InstructionOperands
    IMMEDIATE = ->(operand) { operand.is_a?(Immediate) }

    REGISTER_8_BIT = ->(operand) { operand.is_a?(Register) && operand.width == 8 }
    REGISTER_16_BIT = ->(operand) { operand.is_a?(Register) && operand.width == 16 }

    REGISTER_AL = ->(operand) { operand.is_a?(Register) && operand.name == :al }
    MEMORY_OFFSET_8_BIT = lambda do |operand|
      operand.is_a?(EffectiveAddress) && operand.width == 8
    end
  end

  module InstructionCombinations
    REGISTER_8_BIT_AND_IMMEDIATE = lambda do |ctx|
      return false unless InstructionOperands::IMMEDIATE.call ctx.operand2

      InstructionOperands::REGISTER_8_BIT.call ctx.operand1
    end

    REGISTER_16_BIT_AND_IMMEDIATE = lambda do |ctx|
      return false unless InstructionOperands::IMMEDIATE.call ctx.operand2

      InstructionOperands::REGISTER_16_BIT.call ctx.operand1
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

  include Hexable

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
      when InstructionCombinations::REGISTER_8_BIT_AND_IMMEDIATE
        register = operand1
        0xb0 + register.extension
      when InstructionCombinations::REGISTER_16_BIT_AND_IMMEDIATE
        register = operand1
        0xb8 + register.extension
      else
        raise UnknownPrimaryOpCodeError,
              "Can't determine primary opcode given #{operand1.inspect}, #{operand2.inspect}."
      end
  end

  def to_s
    primary_opcode_as_hex = hex_string(primary_opcode)
    return "#{primary_opcode_as_hex}#{operand2}" if operand1.width == operand2.width

    operand2_as_padded_hex = hex_string(operand2.value, width: operand1.width)
    "#{primary_opcode_as_hex}#{operand2_as_padded_hex}"
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
