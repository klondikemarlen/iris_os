# frozen_string_literal: true

require 'effective_address'
require 'labels'

describe EffectiveAddress do
  subject(:address) { described_class.new(operand) }

  context 'when given a label' do
    let(:label) { Label.new 30, context: nil }
    let(:operand) { [label] }

    it 'returns the effective address of data at that label' do
      expect(address.to_s).to eq '1e00'
    end
  end
end
