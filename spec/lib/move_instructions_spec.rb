# frozen_string_literal: true

require 'base_asm'
require 'definable'
require 'labels'
require 'move_instructions'

describe MoveInstruction do
  subject(:move_instruction) { described_class.new destination, source }

  describe '#to_s' do
    context 'when given an 8 bit register' do
      let(:destination) { Register.new(:al) }

      context 'with an immediate' do
        let(:source) { Immediate.new('H') }

        it 'returns the correct hexadecimal as a string' do
          expect(move_instruction.to_s).to eq 'b048'
        end
      end

      context 'with an 8 bit immediate' do
        let(:source) { Immediate.new(5) }

        it 'returns the correct hexadecimal as a string' do
          expect(move_instruction.to_s).to eq 'b005'
        end
      end

      context 'with an 8 bit address' do
        let(:label) { Label.new(5, context: {}) }
        let(:source) { EffectiveAddress.new(label) }

        it 'returns the correct hexadecimal as a string' do
          expect(move_instruction.to_s).to eq 'a00500'
        end
      end
    end

    context 'when given a 16 bit register' do
      let(:destination) { Register.new(:bx) }

      context 'with an immediate' do
        let(:source) { Immediate.new(0x1e) }

        it 'returns the correct hexadecimal as a string' do
          expect(move_instruction.to_s).to eq 'bb1e00'
        end
      end
    end
  end

  describe '.parse' do
    subject(:result) { described_class.parse(operand) }

    context 'when given an immediate equivalent' do
      let(:operand) { 0x7c00 }
      it 'casts the value to an immediate' do
        expect(result).to be_a(Immediate).and(have_attributes(value: 31_744))
      end
    end

    context 'when given a label' do
      let(:operand) { Label.new(5, context: {}) }

      it 'casts the value to an immediate' do
        expect(result).to be_a(Immediate).and(have_attributes(value: 5))
      end
    end

    context 'when given an array containing a label (segment:offset)' do
      let(:operand) { [Label.new(5, context: {})] }

      it 'casts the value to a Address' do
        expect(result).to be_a(EffectiveAddress).and(have_attributes(value: 5))
      end
    end
  end
end

describe MoveInstructions do
  subject(:assembler) { with_move_instructions.new }

  let(:with_move_instructions) do
    Class.new do
      include BaseAsm
      include Definable
      include Labels
      include MoveInstructions
    end
  end

  context '#mov' do
    context 'when given an 8-bit register' do
      # MOV r8 imm8 - B0+r
      it 'works for an 8-bit hex literal' do
        assembler.build do
          mov ah, 0x0e
        end
        expect(assembler.buffer).to eq 'b40e'
      end

      it 'works for an 8-bit memory address' do
        assembler.build do
          label :the_secret do
            db 'X'
          end
          mov al, [the_secret]
        end
        expect(assembler.buffer).to end_with 'a00000'
      end

      it 'works with a direct label' do
        assembler.build do
          label :the_secret do
            db 'X'
          end

          mov bx, the_secret
        end

        expect(assembler.buffer).to end_with 'bb0000'
      end
    end
  end
end
