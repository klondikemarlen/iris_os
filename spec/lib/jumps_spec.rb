# frozen_string_literal: true

require 'base_asm'
require 'jumps'
require 'labels'

WithJumps = Class.new do
  include BaseAsm
  include Jumps
  include Labels
end

describe WithJumps do
  subject(:asm) { described_class.new }
  context '#jmp' do
    it 'can understand jmp to label' do
      asm.label :endless do
        jmp endless
      end

      expect(asm.buffer).to eq 'e9fdff'
    end

    it 'can jump to the current address (i.e. forever)' do
      asm.build do
        jmp '$'
      end
      expect(asm.buffer).to eq 'e9fdff'
    end
  end
end

describe Jump do
  subject(:jump) do
    described_class.new destination, current_assembly_position: 0,
                                     mode: :'16_BIT_REAL'
  end

  describe '#new' do
    context 'when in 16 bit real mode' do
      let(:destination) { '$' }

      it 'works for the special symbol: $' do
        expect(jump.to_s).to eq 'e9fdff'
      end
    end
  end
end
