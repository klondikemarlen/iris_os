# frozen_string_literal: true

require 'moveable'

describe Moveable do
  subject(:with_moveable) { WithMoveable.new }
  let(:WithMoveable) do
    Class.new do
      include described_class
    end
  end

  context '#mov' do
    # MOV r8 imm8 - B0+r
    it 'works for an 8-bit register and an 8-bit hex literal' do
      with_moveable.build do
        mov ah, 0x0e
      end
      expect(with_moveable.buffer).to eq 'b40e'
    end
  end
end
