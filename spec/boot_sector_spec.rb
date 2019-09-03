# frozen_string_literal: true

require 'asm'

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

describe 'BOOT_SECT' do
  context 'when run' do
    it 'produces the correct hex data' do
      expect(BOOT_SECT.to_s).to eql <<~HEX
        b4 0e b0 48 cd 10 b0 65 cd 10 b0 6c cd 10 b0 6c
        cd 10 b0 6f cd 10 e9 fd ff 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        *
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 55 aa
      HEX
    end
  end
end
