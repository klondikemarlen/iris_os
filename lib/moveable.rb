# frozen_string_literal: true

require 'registers'
require 'immediate'
require 'hexable'

class Move
  include Hexable

  attr_reader :dest, :src, :src_type, :dest_type

  def initialize(destination, source)
    self.src = source
    self.dest = destination
  end

  def dest=(operator)
    @dest = \
      case operator
      when Support::R8
        0xb0 + operator.extension
      end
    self.dest_type = operator
  end

  def dest_type=(operator)
    @dest_type = \
      case operator
      when Support::R8
        :r8
      end
  end

  def src=(operator)
    @src = \
      case operator
      when Numeric
        self.src_type = Immediate.new(operator)
        operator
      end
  end

  def src_type=(operator)
    @src_type = \
      case operator
      when Support::IMM8
        :imm8
      end
  end

  def to_s
    case self
    when Support::R8_IMM8
      to_hex(dest) + to_hex(src)
    end
  end

  def type
    "#{dest_type}_#{src_type}".intern
  end

  module Support
    R8 = ->(op) { op.is_a?(Register) && op.width == 8 }
    IMM8 = ->(op) { op.is_a?(Immediate) && op.width == 8 }
    R8_IMM8 = ->(op) { op.type == :r8_imm8 }
  end
end

module Moveable
  include Registers

  # B0+ rb  MOV r8,imm8   Move imm8 to r8.
  def mov(destination, source)
    instructions << Move.new(destination, source).to_s
  end
end
