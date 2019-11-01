# frozen_string_literal: true

module Definable
  def dw(value)
    @instructions << hex_string(value)
  end
end
