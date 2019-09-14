# frozen_string_literal: true

class Immediate
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def width
    case value.length
    when 2
      8
    when 4
      16
    end
  end
end

module Adders
  OPCODES = Set[
    Set['r/m16', 'imm16', '81 /0 iw'] # ADD r/m16, imm16
  ]

  attr_reader :destination, :source
  # add bx, 0x7c00 -> bx = bx + 0x7c00 -> 81 c3 00 7c
  # 81 c3 00 7c
  # Destination = Destination + Source;
  def add(dest, src)
    @destination = dest
    @source = src
    @instructions << to_hex(AsmCodes::ADD) << destination << source
  end

  def register_width; end

  def source=(value)
    case value
    when Register
      value
    when Immediate
      to_hex(value)
    end
  end
end
