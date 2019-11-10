# frozen_string_literal: true

require 'base_asm'
require 'definable'

WithDefinable = Class.new do
  include BaseAsm
  include Definable
end

describe WithDefinable do
  subject(:with_definable) { described_class.new }

  context '#dw' do
    it 'support define word' do
      with_definable.build do
        dw 0xaa55
      end
      expect(with_definable.buffer).to eql '55aa'
    end
  end

  context '#db' do
    it 'support define bytes' do
      with_definable.build do
        db 'X'
      end
      expect(with_definable.buffer).to eql '58'
    end
  end
end
