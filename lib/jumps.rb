# frozen_string_literal: true

require_relative 'base_asm'
require_relative 'hexable'
require_relative 'labels'

##
# Consider making Jump inherit from Instruction?
# This would require a major rework of Instruction ... but perhaps makes more sense?
class Jump
  include Hexable

  class UnknownAddressError < AsmError; end
  class UnknownOpCodeError < AsmError; end
  class UnknownModeError < AsmError; end

  module Types
    REL_16 = lambda do |jump|
      return false unless jump.mode == :'16_BIT_REAL'
      return true if jump.target == '$'

      jump.target.is_a?(Label)
    end
  end

  attr_reader :target, :current_assembly_position, :mode

  def initialize(target, current_assembly_position:, mode:)
    @target = target
    @current_assembly_position = current_assembly_position
    @mode = mode
  end

  def to_s
    primary_opcode + hex_string(address)
  end

  def primary_opcode
    case self
    when Types::REL_16
      hex_string 0xe9
    else
      raise UnknownOpCodeError,
            "Unknown operation code for #{mode}, #{target} type."
    end
  end

  #######
  private
  #######

  ##
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
      jump_forever
    when Label
      jump_to_location(target.value)
    else
      raise UnknownAddressError, "Unknown address for #{target} target."
    end
  end

  # In 16 bit real mode: 0xffff AND NOT 0x2
  def jump_forever
    jump_to_location(current_assembly_position)
  end

  def jump_to_location(target)
    negative_padded_relative_offset(
      (current_assembly_position + primary_opcode.length) - target
    )
  end

  def negative_padded_relative_offset(relative_offset)
    negative_offset_in_twos_comp = ~relative_offset
    pad_for_negative_twos_comp & negative_offset_in_twos_comp
  end

  ##
  # Consider moving this to hexable?
  def pad_for_negative_twos_comp
    case mode
    when :'16_BIT_REAL'
      0xffff # ('1'*16).to_i(2)
    else
      raise UnknownModeError, "Unknown pad for two complement on #{mode} mode."
    end
  end
end

module Jumps
  ##
  # E9 - JMP rel16
  # Jump near, relative, displacement relative to next instruction.
  def jmp(target)
    @instructions << Jump.new(target, current_assembly_position: cursor,
                                      mode: mode).to_s
  end
end
