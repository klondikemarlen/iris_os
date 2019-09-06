# frozen_string_literal: true

module Jumps
  attr_reader :target

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
