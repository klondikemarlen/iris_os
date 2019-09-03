# frozen_string_literal: true

require_relative 'asm_codes'
require_relative 'hexable'
require_relative 'hex_file'

# TODO: make buffer squish spaces out
# and make it update the cursor position.

class Asm
  include Hexable
  attr_reader :instructions, :symbols

  def initialize
    @symbols = {}
    @instructions = []
  end

  def build(&block)
    instance_eval(&block)
    self
  end

  def self.build(&block)
    new.build(&block)
  end

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
    @instructions << to_hex(value)
  end

  def label(label, &block)
    symbols[label] = to_hex(cursor)
    instance_eval(&block)
  end

  def jmp(label)
    @instructions << to_hex(AsmCodes::JMP) << symbols[label]
  end

  def pad(size, char)
    @instructions << to_hex(char) * (size - buffer.length / 2)
  end
end
