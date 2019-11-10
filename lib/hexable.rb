# frozen_string_literal: true

class Hex
  attr_reader :hex_string

  def initialize(object, bit_width: nil, hex_width: nil)
    raise ArgumentError, 'No nil can become hex!' if object.nil?
    raise ArgumentError, 'Pick either hex_width or bit_width not both' \
      unless hex_width.nil? || bit_width.nil?

    @hex_width = hex_width || (bit_width && bit_width / 4)
    @hex_string = parse_object(object).downcase
  end

  def to_s
    displacement hex_string.rjust(pad_size, pad_char)
  end

  #######
  private
  #######

  def cast_to_ord(char)
    raise ArgumentError, 'Only single characters allowed.' \
      unless char.length == 1

    char.ord.to_s(16)
  end

  def pad_size
    return @hex_width if @hex_width

    hex_string.length + hex_string.length % 2
  end

  def pad_char
    hex_string.start_with?('f') ? 'f' : '0'
  end

  def parse_object(object)
    case object
    when Integer
      @hex_string = object.to_s(16)
    when String
      @hex_string = cast_to_ord(object)
    else
      raise ArgumentError, "No values of type #{object.class}."
    end
  end

  # low byte, high byte
  def displacement(word)
    return word unless word.length == 4

    "#{word[2..4]}#{word[0..1]}"
  end
end

module Hexable
  def hex_string(value, bit_width: nil, hex_width: nil)
    Hex.new(value, bit_width: bit_width, hex_width: hex_width).to_s
  end
end
