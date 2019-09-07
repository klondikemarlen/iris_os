# frozen_string_literal: true

module Definable
  def dw(value)
    @instructions << to_hex(value)
  end
end
