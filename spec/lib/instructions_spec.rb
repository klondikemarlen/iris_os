# frozen_string_literal: true

require 'registers'
require 'immediate'
require 'instructions'

RSpec.describe Instructions::Types::R8_IMM8 do
  subject(:r8_imm8) { described_class }
  let(:instruction) { Instruction.new(:mov, *operators) }
  context 'when an 8-bit register and an 8-bit immediate' do
    let(:operators) { [Register.new(:ah), Immediate.new(0x0e)] }
    it 'is true' do
      expect(r8_imm8.call(instruction)).to be true
    end
  end

  context 'when 3 operators' do
    let(:operators) { [Register.new(:ah), Immediate.new(0x0e), 'f'] }
    it 'is false' do
      expect(r8_imm8.call(instruction)).to be false
    end
  end

  context 'when 2 registers' do
    let(:operators) { [Register.new(:ah), Register.new(:al)] }
    it 'is false' do
      expect(r8_imm8.call(instruction)).to be false
    end
  end

  context 'when 16-bit immediate is passed' do
    let(:operators) { [Register.new(:ah), Immediate.new(0xaa55)] }
    it 'is false' do
      expect(r8_imm8.call(instruction)).to be false
    end
  end
end
