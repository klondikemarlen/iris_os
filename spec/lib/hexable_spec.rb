# frozen_string_literal: true

class DummyClass
  include Hexable
end

describe Hexable do
  subject(:dc) { DummyClass.new }
  context '#to_hex' do
    it 'converts decimals' do
      expect(dc.to_hex(1234)).to eq 'd204'
    end

    it 'converts hex' do
      expect(dc.to_hex(0x234)).to eq '3402'
    end

    it 'converts upper case letters' do
      expect(dc.to_hex('H')).to eq '48'
    end

    it 'converts lower case letters' do
      expect(dc.to_hex('e')).to eq '65'
    end

    it 'raises an error if you pass it a string of hex' do
      expect { dc.to_hex('e9') }.to raise_error ArgumentError
    end
  end
end
