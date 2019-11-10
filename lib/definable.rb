# frozen_string_literal: true

require 'hexable'

module Definable
  include Hexable

  def dw(value)
    @instructions << hex_string(value)
  end

  def db(value)
    @instructions << hex_string(value)
  end
end
