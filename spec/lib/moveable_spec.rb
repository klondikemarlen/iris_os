# frozen_string_literal: true

require 'base_asm'
require 'moveable'

WithMoveable = Class.new do
  include BaseAsm
  include Moveable
end

describe Moveable do
  subject(:with_moveable) { WithMoveable.new }

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
