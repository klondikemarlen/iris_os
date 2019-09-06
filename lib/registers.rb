# frozen_string_literal: true

module Registers
  def mov(to, value)
    instructions << to << to_hex(value)
  end

  AsmCodes::REGISTERS.each do |method, code|
    define_method method do
      to_hex(code)
    end
  end
end
