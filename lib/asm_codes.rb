# frozen_string_literal: true

module AsmCodes
  JMP = 0xe9
  INT = 0xcd
  REGISTERS = { # ax, bx, cx, dx (ah, al ...)
    ah: 0xb4,
    al: 0xb0
  }.freeze
end
