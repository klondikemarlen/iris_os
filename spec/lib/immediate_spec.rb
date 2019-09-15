# frozen_string_literal: true

require 'immediate'

describe Immediate do
  subject(:immediate) { described_class.new value }
  context 'an 8-bit, byte immediate' do
    let(:value) { 0x0e }
    it 'has a width of 8' do
      expect(immediate.width).to eql 8
    end
  end

  context 'a 16-bit, word immediate' do
    let(:value) { 0xaa55 }
    it 'has a width of 16' do
      expect(immediate.width).to eql 16
    end
  end
end
