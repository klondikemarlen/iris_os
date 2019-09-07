# frozen_string_literal: true

module Interrupts
  def int(value)
    instructions << to_hex(AsmCodes::INT) << to_hex(value)
  end
end
