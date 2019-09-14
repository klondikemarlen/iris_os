# frozen_string_literal: true

require 'adders'

WithAdders = Class.new do
  include BaseAsm
  include Registers
  include Hexable
  include Adders
end

describe Adders do
  subject(:with_adders) { WithAdders.new }
  context '#add' do
    # ADD  r/m16 imm16 - opcode 81, 0xC0 + 4 (from register number)
    # Adds 16-bit word to value in a 16-bit register
    # encodes: register = register + word
    it 'adds a double word to a 16-bit register' do
      with_adders.build do
        add bx, 0x7c00
      end
      expect(with_adders.buffer).to eql '81c3 007c'
    end
  end
end
