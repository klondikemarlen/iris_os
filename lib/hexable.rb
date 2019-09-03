# frozen_string_literal: true

module Hexable
  attr_reader :hex

  def to_hex(value)
    case value
    when String
      @hex = value.delete(' ').downcase
      @hex = hex.ord.to_s(16) unless hex.match(/^[0-9a-f]*$/)
    when Integer
      @hex = value.to_s(16)
    end
    hex.rjust(pad_size, '0')
  end

  #######
  private
  #######

  def pad_size
    hex.length + hex.length % 2
  end
end
