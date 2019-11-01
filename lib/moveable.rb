# frozen_string_literal: true

require 'base_error'
require 'hexable'
require 'instructions'

class Move
  include Hexable

  class UnknownInstructionError < AsmError; end

  attr_reader :dest, :src, :instruction

  def initialize(destination, source)
    self.instruction = Instruction.new(:mov, destination, source)
  end

  def instruction=(instr)
    case instr.type
    when :r8_imm8
      @dest = 0xb0 + instr.op1.extension
      @src = instr.op2.value
    else
      raise UnkownInstructionError,
            "Write the code to handle instruction #{instr.type}"
    end
    @instruction = instruction
  end

  def to_s
    hex_string(dest) + hex_string(src)
  end

  def type
    instruction.type
  end
end

module Moveable
  include Registers

  # B0+ rb  MOV r8,imm8   Move imm8 to r8.
  def mov(destination, source)
    @instructions << Move.new(destination, source).to_s
  end
end
