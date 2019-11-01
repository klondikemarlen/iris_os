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

  def cast(object)
    case object
    when Integer
      object
    when String
      cast_to_ord(object)
    else
      raise ArgumentError, "Can't create Immediate from #{value.class}."
    end
  end

  def cast_to_ord(char)
    raise ArgumentError, 'Only single characters allowed.' \
      unless char.length == 1

    char.ord
  end
end
