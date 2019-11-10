# frozen_string_literal: true

require 'hexable'

describe Hexable do
  include described_class

  context '#hex_string' do
    it 'converts decimals' do
      expect(hex_string(1234)).to eq 'd204'
    end

    it 'converts hex' do
      expect(hex_string(0x234)).to eq '3402'
    end

    it 'converts upper case letters' do
      expect(hex_string('H')).to eq '48'
    end

    it 'converts lower case letters' do
      expect(hex_string('e')).to eq '65'
    end

    it 'raises an error if you pass it a string of hex' do
      expect { hex_string('e9') }.to raise_error ArgumentError
    end

    it 'raise an error on nil' do
      expect { hex_string(nil) } .to raise_error ArgumentError
    end

    context 'when padding to a specific width' do
      it "pads positive numbers with 0's" do
        expect(hex_string(0x1e, bit_width: 16)).to eq '1e00'
      end

      it "pads negative numbers with f's" do
        expect(hex_string(0xfd, bit_width: 16)).to eq 'fdff'
      end

      it 'accepts a hex_width' do
        expect(hex_string(0x1e, hex_width: 4)).to eq '1e00'
      end

      it 'fails informatively when passed a bit_width and a hex_width' do
        expect {
          hex_string(0x1e, hex_width: 4, bit_width: 16)
        }.to raise_error ArgumentError,
                         /Pick either hex_width or bit_width not both/
      end
    end
  end
end
