# frozen_string_literal: true

require 'hexable'
require 'asm_codes'

module Jumps
  include Hexable

  attr_reader :target

  # NASM supports two special tokens in expressions, allowing calculations to
  # involve the current assembly position: the $ and $$ tokens. $ evaluates to
  # the assembly position at the beginning of the line containing
  # the expression; so you can code an infinite loop using JMP $. $$ evaluates
  # to the beginning of the current section; so you can tell how far into the
  # section you are by using ($-$$).
  # jmp '$'   ; Jump to the current address (i.e. forever).
  def address
    case target
    when '$'
      twos_comp(-3)
    when '$$'
      raise # I'm not sure what should go here
      # hex_string(cursor + 2) # ?
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
    @instructions << hex_string(AsmCodes::JMP) << hex_string(address)
  end

  def twos_comp(value)
    0xffff & value
  end
end
