# frozen_string_literal: true

require 'addressable'
require 'labels'

describe Address do
  subject(:address) { described_class.new(*operations, width: :word) }

  context 'when given a label' do
    let(:label) { Label.new 30, context: nil }
    let(:operations) { [label] }
    it 'returns the effective address of data at that label' do
      expect(address.to_s).to eq '1e00'
    end
  end
end
