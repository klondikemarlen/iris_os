# frozen_string_literal: true

require 'asm'

describe Asm do
  let(:out_file) { 'tmp/asm_test.bin' }
  let(:asm) { described_class.new }

  describe '.build' do
    context 'when building instructions' do
      it 'can understand jmp to label' do
        asm.build out_file do
          label :loop do
            jmp :loop
          end
        end

        expect(asm.buffer.join).to eq 'e9 fd ff 00'.delete ' '
      end

      it 'can understand pad' do
        asm.build out_file do
          label :loop do
            jmp :loop
          end
          pad 510, 0
        end

        expect(asm.buffer.join.length).to eq 510 * 2
      end

      it 'can understand dw' do
        asm.build out_file do
          label :loop do
            jmp :loop
          end
          pad 510, 0
          dw 0xaa55
        end

        expect(asm.buffer.join[1020..1024]).to eq 'aa55'
      end
    end
  end
end
