# frozen_string_literal: true

require 'base_asm'
require 'labels'

WithLabels = Class.new do
  include BaseAsm
  include Labels
end

describe WithLabels do
  context 'when defined' do
    let(:asm) do
      described_class.build do
        instructions << ['1234'] # pad build point
        label :foo
      end
    end

    it 'adds a function to the assemby instance' do
      expect(asm.respond_to?(:foo)).to be true
    end

    it 'returns a label object' do
      expect(asm.foo).to be_a_kind_of Label
    end

    it 'references build point it was defined at' do
      expect(asm.foo.value).to eq 4
    end
  end

  context 'when passed a block' do
    it 'can refer to itself within that block' do
      expect {
        described_class.build do
          label :endless do
            endless
          end
        end
      }.not_to raise_error
    end
  end

  context 'when called before definition' do
    it 'fails informatively' do
      expect {
        described_class.build do
          non_existent_label
        end
      }.to raise_error NameError, /undefined local variable or method/
    end
  end
end

