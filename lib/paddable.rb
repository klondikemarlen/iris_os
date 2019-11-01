# frozen_string_literal: true

require 'hexable'

module Paddable
  include Hexable

  def pad(size, char)
    if (buffer.length / 2) > size
      raise ArgumentError, 'You have too much code already!'
    end

    @instructions << hex_string(char) * (size - buffer.length / 2)
  end
end
