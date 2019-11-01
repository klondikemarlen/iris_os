# frozen_string_literal: true

require 'hexable'

WithHexable = Class.new { include Hexable }

describe Hexable do
  subject(:with_hexable) { WithHexable.new }
  context '#hex_string' do
    it 'converts decimals' do
      expect(with_hexable.hex_string(1234)).to eq 'd204'
    end

    it 'converts hex' do
      expect(with_hexable.hex_string(0x234)).to eq '3402'
    end

    it 'converts upper case letters' do
      expect(with_hexable.hex_string('H')).to eq '48'
    end

    it 'converts lower case letters' do
      expect(with_hexable.hex_string('e')).to eq '65'
    end

    it 'raises an error if you pass it a string of hex' do
      expect { with_hexable.hex_string('e9') }.to raise_error ArgumentError
    end

    it 'raise an error on nil' do
      expect { with_hexable.hex_string(nil) } .to raise_error ArgumentError
    end
  end
end
