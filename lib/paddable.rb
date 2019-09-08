# frozen_string_literal: true

module Paddable
  def pad(size, char)
    if (buffer.length / 2) > size
      raise ArgumentError, 'You have too much code already!'
    end

    @instructions << to_hex(char) * (size - buffer.length / 2)
  end
end
