# frozen_string_literal: true

require 'immediates'

describe Immediate do
  subject(:immediate) { described_class.new value }

  describe '#new' do
    context 'when passed a character' do
      let(:value) { 'H' }
      it 'converts to its ASCII ordinal' do
        expect(immediate.to_s).to eql '48'
      end
    end

    context 'when passed a many character string' do
      let(:value) { 'Long String' }
      it 'fails informatively' do
        expect { immediate }.to raise_error ArgumentError,
                                            /Only single characters allowed/
      end
    end

    context 'when passed a float (or other thing)' do
      let(:value) { 3.7 }
      it 'fails informatively' do
        expect { immediate }.to raise_error ArgumentError,
                                            /Can't create Immediate from/
      end
    end
  end

  describe '#width' do
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
end
