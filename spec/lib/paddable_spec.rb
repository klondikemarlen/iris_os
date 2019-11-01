# frozen_string_literal: true

require 'base_asm'
require 'paddable'

WithPaddable = Class.new do
  include BaseAsm
  include Paddable
end

describe Paddable do
  subject(:with_paddable) { WithPaddable.new }

  context '#pad' do
    it 'works' do
      with_paddable.build do
        pad 510, 0
      end

      expect(with_paddable.buffer.length).to eq 510 * 2
    end

    it 'raises an error if your pad is less than the current size' do
      expect do
        with_paddable.build do
          @instructions << hex_string(0) * 700 # make pad to 510 be impossible
          pad 510, 0
        end
      end.to raise_error ArgumentError
    end
  end
end
