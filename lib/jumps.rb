# frozen_string_literal: true

module Jumps
  attr_reader :instructions, :symbols, :target

  def initialize
    @symbols = {}
    @instructions = []
  end

  # jmp '$'   ; Jump to the current address (i.e. forever).
  def address
    case target
    when '$'
      twos_comp(-3)
    when '$$'
      raise # I'm not sure what should go here
      # to_hex(cursor + 2) # ?
    else
      twos_comp(symbols[target] - cursor - 1)
    end
  end

  def buffer
    instructions.join
  end

  # position of last instruction in decimal?
  def cursor
    buffer.length
  end

  def label(label, &block)
    symbols[label] = cursor
    instance_eval(&block)
  end

  # E9 - JMP rel16
  # Jump near, relative, displacement relative to next instruction.
  def jmp(target)
    @target = target
    @instructions << to_hex(AsmCodes::JMP) << to_hex(address)
  end

  def twos_comp(value)
    0xffff & value
  end
end
