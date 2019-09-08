# frozen_string_literal: true

describe Asm do
  let(:asm) { described_class.new }

  describe '.build' do
    context 'when building instructions' do
      it 'can understand jmp to label' do
        asm.build do
          label :loop do
            jmp :loop
          end
        end

        expect(asm.hexdump).to eq 'e9 fd ff'
      end

      it 'can understand pad' do
        asm.build do
          pad 510, 0
        end

        expect(asm.buffer.length).to eq 510 * 2
      end

      it '#dw' do
        asm.build do
          dw 0xaa55
        end

        expect(asm.hexdump).to eq '55 aa'
      end
    end
  end
end
