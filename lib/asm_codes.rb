# frozen_string_literal: true

module AsmCodes
  JMP = 'e9 fd ff'
  INT = 'cd'
  REGISTERS = { # ax, bx, cx, dx (ah, al ...)
    ah: 'b4',
    al: 'b0'
  }.freeze
end
