# frozen_string_literal: true

require 'registers'
require 'immediate'
require 'hexable'
require 'instructions'

class Move
  include Hexable

  attr_reader :dest, :src, :src_type, :dest_type, :instruction

  def initialize(destination, source)
    @instruction = Instruction.new(:mov, destination, source)
    @src = source
    self.dest = destination
  end

  def dest=(operator)
    @dest = \
      case instruction.type
      when :r8_imm8
        0xb0 + operator.extension
      end
  end

  def to_s
    case type
    when :r8_imm8
      to_hex(dest) + to_hex(src)
    end
  end

  def type
    instruction.type
  end
end

module Moveable
  include Registers

  # B0+ rb  MOV r8,imm8   Move imm8 to r8.
  def mov(destination, source)
    instructions << Move.new(destination, source).to_s
  end
end
