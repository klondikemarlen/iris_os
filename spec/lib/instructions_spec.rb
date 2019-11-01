# frozen_string_literal: true

require 'instructions'
require 'labels'

describe Instruction do
  subject(:instruction) { described_class.new :mov, *operators }

  describe '#new' do
    context 'when given a register and an hex integer' do
      let(:operators) { [Register.new(:ah), 0x0e] }
      it 'converts to immediate' do
        expect(instruction.op2).to be_kind_of Immediate
      end
    end

    context 'when given a register and a label' do
      let(:operators) { [Register.new(:ah), Label.new(10, context: {})] }
      it 'converts the label to immediate' do
        expect(instruction.op2).to be_kind_of Immediate
      end
    end

    context 'when passed bad data' do
      let(:operators) { ['bad operator', 'other bad operator'] }
      it 'fails informatively' do
        expect { instruction }.to raise_error ArgumentError,
                                              /Only single characters allowed/
      end
    end

    context 'when no type found' do
      let(:operators) { [Register.new(:zmm7)] }
      it 'fails imformatively' do
        expect { instruction }.to raise_error ArgumentError,
                                              /No type matcher for/
      end
    end
  end

  describe '#type' do
    context 'when given an 8-bit registers and an 8-bit immediate' do
      let(:operators) { [Register.new(:ah), Immediate.new(0x0e)] }

      it 'returns the correct symbol' do
        expect(instruction.type).to be :r8_imm8
      end
    end
  end
end

describe Instructions::Types::R8_IMM8 do
  subject(:r8_imm8) { described_class }
  let(:instruction) { Instruction.new(:mov, *operators, fast_fail: false) }

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
