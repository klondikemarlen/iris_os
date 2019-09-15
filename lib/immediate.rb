# frozen_string_literal: true

require 'hexable'

# Considering merging hexable and immediate ...
class Immediate
  include Hexable

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def width
    to_hex(value).length * 4
  end
end
