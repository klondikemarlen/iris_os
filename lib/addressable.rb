# frozen_string_literal: true

require_relative 'asm_error'
require_relative 'hexable'

class Address
  include Hexable

  class AddressParseError < AsmError; end

  attr_reader :operands, :location

  def initialize(operands, width:)
    @operands = operands
    @width = width
    @location = parse_operands
  end

  def to_s
    hex_string(location, width: @width)
  end

  #######
  private
  #######

  def parse_operands
    case operands
    when Label
      operands.offset
    else
      raise AddressParseError, "No parser for operation type #{operation}."
    end
  end
end
