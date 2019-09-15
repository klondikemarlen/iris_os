# frozen_string_literal: true

module Operators
  module Types
    R8 = ->(op) { op.is_a?(Register) && op.width == 8 }
    IMM8 = ->(op) { op.is_a?(Immediate) && op.width == 8 }
  end
end
