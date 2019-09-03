# frozen_string_literal: true

module Hexable
  attr_reader :hex

  def to_hex(value)
    case value
    when String
      @hex = value.delete(' ')
      @hex = hex.ord.to_s(16) if hex.length == 1
      @hex = hex.ord.to_s(16) unless hex.match(/^[0-9A-Fa-f]*$/)
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
