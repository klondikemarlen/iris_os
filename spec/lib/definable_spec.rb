# frozen_string_literal: true

WithDefinable = Class.new do
  include BaseAsm
  include Hexable
  include Definable
end

describe Definable do
  subject(:with_definable) { WithDefinable.new }
  context '#dw' do
    it 'support define word' do
      with_definable.build do
        dw 0xaa55
      end
      expect(with_definable.buffer).to eql '55aa'
    end
  end
end
