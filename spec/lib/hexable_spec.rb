# frozen_string_literal: true

require 'hexable'

WithHexable = Class.new { include Hexable }

RSpec.describe Hexable do
  subject(:with_hexable) { WithHexable.new }
  context '#to_hex' do
    it 'converts decimals' do
      expect(with_hexable.to_hex(1234)).to eq 'd204'
    end

    it 'converts hex' do
      expect(with_hexable.to_hex(0x234)).to eq '3402'
    end

    it 'converts upper case letters' do
      expect(with_hexable.to_hex('H')).to eq '48'
    end

    it 'converts lower case letters' do
      expect(with_hexable.to_hex('e')).to eq '65'
    end

    it 'raises an error if you pass it a string of hex' do
      expect { with_hexable.to_hex('e9') }.to raise_error ArgumentError
    end
  end
end
