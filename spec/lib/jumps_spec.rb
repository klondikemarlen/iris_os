# frozen_string_literal: true

class DummyClass
  include Jumps
end

describe Jumps do
  subject(:dc) { DummyClass.new }
  context '#jmp' do
    it 'can understand jmp to label' do
      dc.label :loop do
        jmp :loop
      end

      expect(dc.buffer).to eq 'e9fdff'
    end

    it 'can jump to the current address (i.e. forever)' do
      expect(dc.jmp('$').join).to eq 'e9fdff'
    end
  end
end
