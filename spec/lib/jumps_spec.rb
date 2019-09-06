# frozen_string_literal: true

WithJumps = Class.new do
  include BaseAsm
  include Hexable
  include Jumps
end

describe Jumps do
  subject(:with_jumps) { WithJumps.new }
  context '#jmp' do
    it 'can understand jmp to label' do
      with_jumps.label :loop do
        jmp :loop
      end

      expect(with_jumps.buffer).to eq 'e9fdff'
    end

    it 'can jump to the current address (i.e. forever)' do
      expect(with_jumps.jmp('$').join).to eq 'e9fdff'
    end
  end
end
