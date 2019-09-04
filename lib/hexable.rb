# frozen_string_literal: true

module Hexable
  attr_reader :hex

  def to_hex(value)
    case value
    when String
      @hex = value.ord.to_s(16)
    when Integer
      @hex = value.to_s(16)
    end
    hex.downcase.rjust(pad_size, '0')
  end

  #######
  private
  #######

  def pad_size
    hex.length + hex.length % 2
  end
end
