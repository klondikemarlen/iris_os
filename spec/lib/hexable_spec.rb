# frozen_string_literal: true

class DummyClass
  include Hexable
end

describe Hexable do
  subject(:dc) { DummyClass.new }
  context '#to_hex' do
    it 'converts decimals' do
      expect(dc.to_hex(1234)).to eq '04d2'
    end

    it 'converts hex' do
      expect(dc.to_hex(0x234)).to eq '0234'
    end

    it 'converts upper case letters' do
      expect(dc.to_hex('H')).to eq '48'
    end

    # NOTE: to specify a litteral hex `e` do 0xe
    it 'converts lower case letters' do
      expect(dc.to_hex('e')).to eq '65'
    end

    it 'converts uppercase hex with spaces' do
      expect(dc.to_hex('E9 FD FF 00')).to eq 'e9fdff00'
    end
  end
end
