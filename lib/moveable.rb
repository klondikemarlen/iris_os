# frozen_string_literal: true

require_relative 'registers'

module Moveable
  # should move to Moveable Module ...
  attr_reader :destination, :source

  # B0+ rb  MOV r8,imm8   Move imm8 to r8.
  def mov(dest, src)
    @destination = dest
    @source = src
    instructions << destination << source
  end

  def destination=(operation)
    case operation.class
    when Register
      case operation.width
      when 8
        0xb0 + operation.number
      end
    end
  end

  def source=(operation)
    @source = operation
  end
end
