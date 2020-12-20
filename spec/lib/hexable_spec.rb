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

    it 'raises an error on a multi-character string' do
      expect { hex_string('e9') }.to raise_error Hex::MultiCharStringError
    end

    it 'converts negatives to two complement' do
      expect(hex_string(-3)).to eq 'fd'
    end

    it 'raise an error on nil' do
      expect { hex_string(nil) }.to raise_error Hex::NoNilError
    end

    context 'when padding to a specific width' do
      it "pads positive numbers with 0's" do
        expect(hex_string(0x1e, width: :dw)).to eq '1e00'
      end

      it "pads negative numbers with f's" do
        expect(hex_string(-3, width: :dw)).to eq 'fdff'
      end

      it 'accepts :word or dw' do
        expect(hex_string(-3, width: :word)).to eq 'fdff'
      end

      it 'fails informatively when passed an unknown width' do
        expect {
          hex_string(0x1e, width: :bad_name)
        }.to raise_error Hex::UnknownWidthError,
                         /No match for width type/
      end
    end

    context 'when given a bit width as a number of bits' do
      it 'padds correctly' do
        expect(hex_string(0x1e, width: 16)).to eq '1e00'
      end
    end
  end

  context 'when using Hexable Integer refinement' do
    using described_class

    it 'prints integers as hex strings' do
      expect(0xc3.to_s).to eq('c3')
    end

    it 'prints integers as hex strings' do
      expect(195.to_s).to eq('c3')
    end

    it 'still allows inspecting of integers' do
      expect(0xb3.inspect).to eq('179')
    end
  end
end
