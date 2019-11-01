# frozen_string_literal: true

class Hex
  attr_reader :hex_string

  def initialize(object)
    raise ArgumentError, 'No nil can become hex!' if object.nil?

    case object
    when Integer
      @hex_string = object.to_s(16)
    when String
      @hex_string = cast_to_ord(object)
    else
      raise ArgumentError, "No values of type #{object.class}."
    end
  end

  def to_s
    displacement hex_string.downcase.rjust(pad_size, '0')
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
    hex_string.length + hex_string.length % 2
  end

  # low byte, high byte
  def displacement(word)
    return word unless word.length == 4

    "#{word[2..4]}#{word[0..1]}"
  end
end

module Hexable
  def hex_string(value)
    Hex.new(value).to_s
  end
end
