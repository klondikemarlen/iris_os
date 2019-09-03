# frozen_string_literal: true

require 'hex_file'

describe HexFile do
  let(:test_file) { 'tmp/hex_writer_test.bin' }
  let(:hexdump) { `hexdump #{test_file}` }

  describe '.write' do
    context 'when writing hex' do
      let(:first_word) { hexdump[8..11] }
      let(:second_word) { hexdump[13..16] }

      it 'the first word is in the correct order' do
        described_class.write test_file do
          'e9 fd'
        end
        expect(first_word).to eq 'e9fd'
      end

      it 'the second word is in the correct order' do
        described_class.write test_file do
          'e9 fd ff 00'
        end

        expect(second_word).to eq 'ff00'
      end
    end
  end

  describe '.read' do
    context 'when reading hex' do
      it 'the first word is in the correct order' do
        described_class.write test_file do
          'e9 fd'
        end
        data = described_class.read test_file
        expect(data).to eq 'e9fd'
      end
    end
  end
end
