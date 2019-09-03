# frozen_string_literal: true

require './lib/asm'

BOOT_SECT = Asm.build do
  mov ah, 0x0e
  mov al, 'H'
  int 0x10
  mov al, 'e'
  int 0x10
  mov al, 'l'
  int 0x10
  mov al, 'l'
  int 0x10
  mov al, 'o'
  int 0x10
  jmp '$'
  pad 510, 0
  dw 0xaa55
end
