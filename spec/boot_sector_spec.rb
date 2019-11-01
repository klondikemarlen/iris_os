# frozen_string_literal: true

require 'asm'

describe 'boot sector' do
  context 'when run on v1 code' do
    let(:boot_sect) do
      Asm.build do
        label :endless do
          jmp endless
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

  context 'when run on v3 code' do
    let(:boot_sect) do
      Asm.build do
        label :the_secret do
          db 'X'
        end

        mov ah, 0x0e # scrolling teletype BIOS routine

        # first attempt
        mov al, the_secret
        int 0x10

        # second attempt
        mov al, [the_secret]
        int 0x10

        # third attempt
        mov bx, the_secret
        add bx, 0x7c00
        mov al, [bx]
        int 0x10

        # fourth attempt
        mov al, [0x7c1e]
        int 0x10

        jmp '$' # jump forever

        # padding and magic boot block BIOS id number
        pad 510, 0
        dw 0xaa55
      end
    end
    it 'produces the correct output' do
      expect(boot_sect.hexdump).to eql <<~HEX.chomp
        b4 0e b0 1e cd 10 a0 1e 00 cd 10 bb 1e 00 81 c3
        00 7c 8a 07 cd 10 a0 1e 7c cd 10 e9 fd ff 58 00
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        *
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 55 aa
      HEX
    end
  end
end
