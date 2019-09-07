# frozen_string_literal: true

WithInterrupts = Class.new do
  include BaseAsm
  include Hexable
  include Interrupts
end

describe Interrupts do
  subject(:with_interrupts) { WithInterrupts.new }
  context '#int' do
    it 'can understand int instructions' do
      with_interrupts.build do
        int 0x10
      end
      expect(with_interrupts.buffer).to eql 'cd10'
    end
  end
end
