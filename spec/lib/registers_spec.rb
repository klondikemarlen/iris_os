# frozen_string_literal: true

require 'registers'

WithRegisters = Class.new do
  include Registers
end

RSpec.describe Registers do
  subject(:with_registers) { WithRegisters.new }

  context '#ah' do
    let(:register) { with_registers.ah }
    it 'has the correct width' do
      expect(register.width).to eq 8
    end

    it 'has the correct number' do
      expect(register.number).to eq 4
    end
  end

  context '#al' do
    let(:register) { with_registers.al }
    it 'has the correct width' do
      expect(register.width).to eq 8
    end

    it 'has the correct number' do
      expect(register.number).to eq 0
    end
  end

  context '#bx' do
    let(:register) { with_registers.bx }
    it 'has the correct width' do
      expect(register.width).to eq 16
    end

    it 'has the correct number' do
      expect(register.number).to eq 3
    end
  end
end
