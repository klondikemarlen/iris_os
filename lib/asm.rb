# frozen_string_literal: true

require_relative 'asm_codes'
require_relative 'base_asm'
require_relative 'definable'
require_relative 'hex_file'
require_relative 'hexable'
require_relative 'interrupts'
require_relative 'jumps'
require_relative 'registers'

# TODO: make buffer squish spaces out
# and make it update the cursor position.

class Asm
  include BaseAsm
  include Definable
  include Hexable
  include Interrupts
  include Jumps
  include Registers

  #######
  private
  #######

  def pad(size, char)
    @instructions << to_hex(char) * (size - buffer.length / 2)
  end
end
