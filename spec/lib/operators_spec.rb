# frozen_string_literal: true

require 'operators'
require 'registers'
require 'immediate'

describe Operators::Types::R8 do
  subject(:r8) { described_class }

  context 'when given an 8-bit register' do
    let(:operator) { Register.new(:ah) }
    it 'is true' do
      expect(r8.call(operator)).to be true
    end
  end

  context 'when given a non-register' do
    let(:operator) { 0xb0 }
    it 'is false' do
      expect(r8.call(operator)).to be false
    end
  end

  context 'when given a 16-bit register' do
    let(:operator) { Register.new(:bx) }
    it 'is false' do
      expect(r8.call(operator)).to be false
    end
  end
end

describe Operators::Types::IMM8 do
  subject(:imm8) { described_class }
  context 'when given an 8-bit immediate' do
    let(:operator) { Immediate.new(0x0e) }
    it 'is true' do
      expect(imm8.call(operator)).to be true
    end
  end

  context 'when given a non-immediate' do
    let(:operator) { Register.new(:ah) }
    it 'is false' do
      expect(imm8.call(operator)).to be false
    end
  end

  context 'when given a 16-bit immediate' do
    let(:operator) { Immediate.new(0xaa55) }
    it 'is false' do
      expect(imm8.call(operator)).to be false
    end
  end
end
