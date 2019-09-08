# frozen_string_literal: true

require 'asm'

describe 'boot sector' do
  context 'when run on v1 code' do
    let(:boot_sect) do
      Asm.build do
        label :loop do
          jmp :loop
        end
        pad 510, 0
        dw 0xaa55
      end
    end
    it 'is correct' do
      expect(boot_sect.hexdump).to eql <<~HEX.chomp
        e9 fd ff 00 00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        *
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 55 aa
      HEX
    end
  end
  context 'when run on v2 code' do
    let(:boot_sect) do
      Asm.build do
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
    end
    it 'produces the correct hex data' do
      expect(boot_sect.hexdump).to eql <<~HEX.chomp
        b4 0e b0 48 cd 10 b0 65 cd 10 b0 6c cd 10 b0 6c
        cd 10 b0 6f cd 10 e9 fd ff 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        *
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 55 aa
      HEX
    end
  end
end
