# frozen_string_literal: true

require 'base_asm'
require 'definable'
require 'labels'

WithLabels = Class.new do
  include BaseAsm
  include Definable
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
      expect(asm.foo.offset).to eq 4
    end
  end

  context 'when passed a block' do
    let(:asm) do
      described_class.build do
        label :some_label do
          db 'X'
        end
      end
    end

    it 'can refer to itself within that block' do
      expect {
        described_class.build do
          label :endless do
            endless
          end
        end
      }.not_to raise_error
    end

    it 'can access the global context from within that block' do
      expect {
        described_class.build do
          label :some_label do
            db 'X'
          end
        end
      }.not_to raise_error
    end

    it 'maintains the offset it had during definition' do
      expect(asm.some_label.offset).to eq 0
    end
  end

  # consider making this define a proto-label?
  # this would crash the assembler if no actual label was defined later.
  context 'when called before definition' do
    # let(:asm) do
    #   described_class.build do
    #     lazy_defined_label
    #     label :lazy_defined_label
    #   end
    # end

    # it 'lazy evaluates' do
    #   expect { asm }.not_to raise_error
    # end

    context 'when not defined at all' do
      it 'fails informatively' do
        expect {
          described_class.build do
            non_existent_label
          end
        }.to raise_error NameError, /undefined local variable or method/
      end
    end
  end
end
