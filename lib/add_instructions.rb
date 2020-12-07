# frozen_string_literal: true

require 'asm_error'
require 'immediates'
require 'registers'

class AddInstuction
  module InstructionOperands
    REGISTER_16_BIT = ->(operand) { operand.is_a?(Register) && operand.width == 16 }
    IMMEDIATE_16_BIT = ->(operand) { operand.is_a?(Immediate) && operand.width == 16 }
  end

  module InstructionCombinations
    REGISTER_16_BIT_AND_IMMEDIATE_16_BIT = lambda do |ctx|
      return false unless InstructionOperands::IMMEDIATE_16_BIT.call(ctx.operand2)

      InstructionOperands::REGISTER_16_BIT.call ctx.operand1
    end
  end

  class AddInstructionError < AsmError; end
  class UnknownPrimaryOpCodeError < AddInstructionError; end
  class OperandParseError < AddInstructionError; end

  class << self
    def parse(operand)
      return Immediate.new(operand) if immediate_equivalent?(operand)

      raise OperandParseError, "No type match for source class #{operand.class}."
    end

    def immediate_equivalent?(operand)
      [Integer, String].any? { |klass| operand.is_a?(klass) }
    end
  end

  attr_reader :operand1, :operand2

  def initialize(operand1, operand2)
    @operand1 = operand1
    @operand2 = operand2
  end

  def primary_opcode
    @primary_opcode ||= \
      case self
      when InstructionCombinations::REGISTER_16_BIT_AND_IMMEDIATE_16_BIT
        0x81
      else
        raise UnknownPrimaryOpCodeError,
              "Can't determine primary opcode given #{operand1}, #{operand2}"
      end
  end

  ##
  # add bx, 0x7c00
  # destination is the 16 bit register bx
  # source is the 16 bit immediate 0x7c00
  # 0xc0 + 0x3 (bx register opcode extension)
  # http://www.c-jump.com/CIS77/CPU/x86/X77_0210_encoding_add_immediate.htm
  # http://ref.x86asm.net/coder.html#x81
  # https://www.sandpile.org/x86/opc_rm16.htm
  def register_byte
    case primary_opcode
    when 0x81
      register = operand1
      mod = '11'
      reg = '000' # for add immediate instruction
      rm = register.extension.to_s(2).rjust(3, '0')
      "#{mod}#{reg}#{rm}".to_i(2)
    end
  end

  def to_s
    "#{primary_opcode.to_s(16)}#{register_byte.to_s(16)} #{operand2}"
  end
end

module AddInstructions
  include Registers

  # add bx, 0x7c00 -> bx = bx + 0x7c00 -> 81 c3 00 7c
  # 81 c3 00 7c
  # Destination = Destination + Source;
  def add(destination, source)
    parsed_source = AddInstuction.parse(source)
    @instructions << AddInstuction.new(destination, parsed_source).to_s
  end
end
