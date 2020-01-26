# frozen_string_literal: true

require 'base_error'
require 'hexable'
require 'immediates'
require 'refinements/naming'

using Refinements::Naming

##
# What is a label?
# it is just an overloaded Ruby `def` that returns a label object
#
# When used it can be an immediate of a specific width that
# matches the register it is being pushed into.
#
# Or
#
# A label is used to calculate the effective address of some data.
# A label holds the relative offset from the start of the section.=end
#
class Label
  include Hexable

  class UndefinedLabelError < AsmError; end
  class AlreadyDefinedError < AsmError; end

  attr_reader :offset, :data, :context

  def initialize(offset, context:)
    @offset = offset
    @context = context
  end

  def to_imm
    Immediate.new(offset)
  end

  def to_s
    hex_string offset
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

    # mod = Object.const_set(symbol.classify, Module.new)
    label = Label.new(cursor, context: block&.binding || binding)

    define_singleton_method(symbol) do
      label
    end

    instance_eval(&block) if block_given?
    public_send(symbol)
  end

  # attr_reader :callbacks

  # def initialize(*args, **kwargs)
  #   super(*args, **kwargs)

  #   @callbacks = []
  # end

  # def method_missing(method, *args, &block)
  #   callbacks << [method, args, block]
  # end

  # def respond_to_missing?(method, inclued_private = false)

  # end

  # def resolve_callbacks
  #   callbacks.each do |callback|
  #     method, args, block = callback
  #     send(method, *args, &block)
  #   end
  # end

  # def build(&block)
  #   super(&block)

  #   resolve_callbacks
  # end
end
