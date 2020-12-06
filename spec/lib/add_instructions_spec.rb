# frozen_string_literal: true

require 'add_instructions'
require 'base_asm'

describe AddInstuction do
  subject(:add_instruction) { described_class.new(destination, source) }

  let(:destination) { Register.new(:bx) }
  let(:source) { Immediate.new(0x7c00) }

  describe '#to_s' do
    context 'when adding the bx register to an immediate' do
      it 'serailizes to the correct string' do
        expect(add_instruction.to_s).to eql '81c3 007c'
      end
    end
  end

  describe '.parse' do
    context 'when given an immediate equivalent' do
      it 'casts the value to an immediate' do
        expect(described_class.parse(0x7c00)).to \
          be_a(Immediate).and(have_attributes(value: 31_744))
      end
    end
  end
end

describe Adders do
  subject(:assembler) { with_adders.new }

  let(:with_adders) do
    Class.new do
      include BaseAsm
      include Adders
    end
  end

  context '#add' do
    # ADD  r/m16 imm16 - opcode 81, 0xC0 + 3 (from register number)
    # Adds 16-bit word to value in a 16-bit register
    # encodes: register = register + word
    it 'adds a double word to a 16-bit register' do
      assembler.build do
        add bx, 0x7c00
      end
      expect(assembler.buffer).to eql '81c3 007c'
    end
  end
end
