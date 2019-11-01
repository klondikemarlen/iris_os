# frozen_string_literal: true

require 'base_error'
require 'hexable'
require 'immediates'

=begin
What is a label?
it is just an overloaded Ruby `def` that returns a label object

When used it can be an immediate of a specific width that
matches the register it is being pushed into.

Or
It can be an address to a block of code?
=end
class Label
  include Hexable

  class UndefinedLabelError < AsmError; end
  class AlreadyDefinedError < AsmError; end

  attr_reader :value, :data, :context

  def initialize(value, context:)
    binding.pry if value == :endless
    @value = value
    @context = context
  end

  def to_imm
    Immediate.new(@value)
  end

  def to_s
    hex_string @value
  end
end

module Labels
  ##
  # basically an overloaded Ruby `def` statement
  # that returns a label object
  def label(symbol, &block)
    # I'm not sure if I should disallow label reuse or not ...
    # raise(Label::AlreadyDefinedError, "Label `:#{symbol}` already exists.") \
    #   if respond_to?(symbol)

    define_singleton_method(symbol) do
      Label.new(cursor, context: binding)
    end

    instance_eval(&block) if block_given?
    public_send(symbol)
  end
end
