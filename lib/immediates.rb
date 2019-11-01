# frozen_string_literal: true

require 'hexable'

# Considering merging hexable and immediate ...
class Immediate
  include Hexable

  attr_reader :value

  def initialize(value)
    @value = cast(value)
  end

  def width
    to_s.length * 4
  end

  def to_s
    hex_string value
  end

  #######
  private
  #######

  def cast(value)
    return value if value.is_a? Integer
    return cast_to_ord(value) if value.is_a? String
    return lookup_label(value) if value.is_a? Symbol

    raise ArgumentError, "Can't create Immediate from #{value.class}."
  end

  def cast_to_ord(char)
    unless char.is_a? String
      raise ArgumentError, 'Can only cast String to ordinal.'
    end

    unless char.length == 1
      raise ArgumentError, 'Only single characters allowed.'
    end

    char.ord
  end

  def lookup_label(value)
    value
  end
end
