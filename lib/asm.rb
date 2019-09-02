# frozen_string_literal: true

require_relative 'asm_codes'
require_relative 'hex_file'

# TODO: make buffer squish spaces out
# and make it update the cursor position.

class Asm
  attr_reader :buffer, :symbols

  def initialize
    @buffer = [] # out_file?
    @symbols = {}
  end

  def build(path, &block)
    instance_eval(&block)
    HexFile.write path do
      compressed_buffer
    end
  end

  #######
  private
  #######

  # TODO: make the buffer class do this automagically.
  def compressed_buffer
    buffer.join
  end

  # position of last instruction in decimal?
  def cursor
    compressed_buffer.length / 2
  end

  def dw(value)
    @buffer << safe(value)
  end

  def label(label, &block)
    symbols[label] = safe(cursor)
    instance_eval(&block)
  end

  def jmp(label)
    @buffer << safe(AsmCodes::JMP) << symbols[label]
  end

  def pad(size, char)
    @buffer << safe(char) * (size - compressed_buffer.length / 2)
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
