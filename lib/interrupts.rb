# frozen_string_literal: true

module Interrupts
  def int(value)
    instructions << hex_string(AsmCodes::INT) << hex_string(value)
  end
end
