# frozen_string_literal: true

require_relative 'asm_codes'
require_relative 'add_instructions'
require_relative 'base_asm'
require_relative 'definable'
require_relative 'hex_file'
require_relative 'hexable'
require_relative 'interrupts'
require_relative 'jumps'
require_relative 'labels'
require_relative 'move_instructions'
require_relative 'paddable'
require_relative 'registers'

# TODO: make buffer squish spaces out
# and make it update the cursor position.

class Asm
  include AddInstructions
  include BaseAsm
  include Definable
  include Hexable
  include Interrupts
  include Jumps
  include Labels
  include MoveInstructions
  include Paddable
  include Registers
end
