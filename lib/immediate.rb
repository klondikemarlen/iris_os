# frozen_string_literal: true

require 'hexable'

# Considering merging hexable and immediate ...
class Immediate
  include Hexable

  attr_reader :value

  def initialize(value)
    if value.is_a? Integer
      @value = value
      return
    end

    @value = cast_to_ord(value)
  end

  def width
    to_s.length * 4
  end

  def to_s
    to_hex(value)
  end

  #######
  private
  #######

  def cast_to_ord(char)
    unless char.is_a? String
      raise ArgumentError, 'Can only cast String to ordinal.'
    end

    unless char.length == 1
      raise ArgumentError, 'Only single characters allowed.'
    end

    char.ord
  end
end
