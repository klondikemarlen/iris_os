# frozen_string_literal: true

require_relative 'asm_error'
require_relative 'hexable'

class EffectiveAddress
  include Hexable

  class AddressParseError < AsmError; end

  WIDTH_TRANSLATION = {
    8 => :word, # should be byte ... but nasm produces extra 00
    16 => :word
  }.freeze

  attr_reader :operand

  def initialize(expression)
    @operand, = *expression
  end

  def value
    @value ||= operand.offset
  end

  def width
    @width ||= operand.to_imm.width
  end

  def to_s
    hex_string(value, width: WIDTH_TRANSLATION[width])
  end
end
