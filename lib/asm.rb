# frozen_string_literal: true

require_relative 'asm_codes'
require_relative 'hex_file'

# TODO: make buffer squish spaces out
# and make it update the cursor position.

class Asm
  attr_reader :instructions, :symbols

  def initialize
    @symbols = {}
    @instructions = []
  end

  def build(&block)
    instance_eval(&block)
  end

  # TODO: make the buffer class do this automagically.
  def buffer
    instructions.join
  end

  #######
  private
  #######

  # position of last instruction in decimal?
  def cursor
    buffer.length / 2
  end

  def dw(value)
    @instructions << safe(value)
  end

  def label(label, &block)
    symbols[label] = safe(cursor)
    instance_eval(&block)
  end

  def jmp(label)
    @instructions << safe(AsmCodes::JMP) << symbols[label]
  end

  def pad(size, char)
    @instructions << safe(char) * (size - buffer.length / 2)
  end

  def safe(value)
    case value
    when String
      value.delete(' ').rjust(2, '0')
    when Integer
      value.to_s(16).rjust(2, '0')
    end
  end
end
