# frozen_string_literal: true

class Hex
  attr_reader :value, :hex_string

  def initialize(value)
    raise ArgumentError, 'No nil can become hex!' if value.nil?

    @value = value
  end

  def to_s
    case value
    when String
      raise ArgumentError, 'No strings of hex!' if value.length > 1

      @hex_string = value.ord.to_s(16)
    when Integer
      @hex_string = value.to_s(16)
    end
    displacement hex_string.downcase.rjust(pad_size, '0')
  end

  #######
  private
  #######

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
  def to_hex(value)
    Hex.new(value).to_s
  end
end
