# frozen_string_literal: true

require 'base_error'

class Hex
  class UnknownWidthError < AsmError; end
  class MultiCharStringError < AsmError; end
  class NoNilError < AsmError; end

  attr_reader :hex_string

  def initialize(object, width: nil)
    raise NoNilError, 'No nil can become hex!' if object.nil?

    @pad_char = ''
    @hex_width = symolic_width_to_hex_size(width)
    @hex_string = parse_object(object)
  end

  def to_s
    displacement hex_string.rjust(pad_size, @pad_char)
  end

  #######
  private
  #######

  def cast_to_ord(char)
    raise MultiCharStringError, 'Only single characters allowed.' \
      unless char.length == 1

    @pad_char = '0'
    char.ord.to_s(16)
  end

  # low byte, high byte
  def displacement(word)
    return word unless word.length == 4

    "#{word[2..4]}#{word[0..1]}"
  end

  def pad_size
    return @hex_width if @hex_width

    hex_string.length + hex_string.length % 2
  end

  def parse_integer(int)
    unless int.negative?
      @pad_char = '0'
      return int.to_s(16)
    end

    @pad_char = 'f'
    twos_complement_as_hex(int)
  end

  def parse_object(object)
    case object
    when Integer
      parse_integer(object)
    when String
      cast_to_ord(object)
    else
      raise ArgumentError, "No values of type #{object.class}."
    end
  end

  ##
  # The size in bits / 4
  def symolic_width_to_hex_size(width)
    return nil if width.nil?

    if %i[byte db].include?(width)
      2
    elsif %i[word dw].include?(width)
      4
    else
      raise UnknownWidthError, "No match for width type #{width.inspect}."
    end
  end

  def twos_complement_as_hex(negative_int)
    num_bytes = negative_int.to_s(16).length - 1
    mask = "0x#{'f' * num_bytes}".to_i(16)
    (mask & negative_int).to_s(16)
  end
end

module Hexable
  def hex_string(value, width: nil)
    Hex.new(value, width: width).to_s
  end
end
