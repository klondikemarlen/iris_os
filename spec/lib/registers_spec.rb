# frozen_string_literal: true

WithRegisters = Class.new do
  include BaseAsm
  include Registers
  include Hexable
end

describe Registers do
  subject(:with_registers) { WithRegisters.new }
  context '#mov' do
    it 'accepts a register and a hex literal' do
      with_registers.build do
        mov ah, 0x0e
      end
      expect(with_registers.buffer).to eq 'b40e'
    end
  end
end
