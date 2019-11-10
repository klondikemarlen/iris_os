# frozen_string_literal: true

require 'base_asm'
require 'definable'
require 'labels'
require 'moveable'

WithMoveable = Class.new do
  include BaseAsm
  include Definable
  include Labels
  include Moveable
end

describe Moveable do
  subject(:with_moveable) { WithMoveable.new }

  context '#mov' do
    context 'when given an 8-bit register' do
      # MOV r8 imm8 - B0+r
      it 'works for an 8-bit hex literal' do
        with_moveable.build do
          mov ah, 0x0e
        end
        expect(with_moveable.buffer).to eq 'b40e'
      end

      it 'works for an 8-bit memory address' do
        with_moveable.build do
          label :the_secret do
            db 'X'
          end
          mov al, [the_secret]
        end
      end
    end
  end
end

describe Move do
  subject(:move) { described_class.new destination, source }
  let(:destination) { Register.new(:al) }

  describe '#new' do
    context 'when given a register and a character' do
      let(:source) { 'H' }
      it 'works' do
        expect(move.to_s).to eq 'b048'
      end
    end

    context 'when give a register and a label' do
      let(:source) { Label.new(5, context: {}) }
      it 'works' do
        expect(move.to_s).to eql 'b005'
      end
    end
  end
end
