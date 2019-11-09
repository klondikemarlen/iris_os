# frozen_string_literal: true

require_relative 'hexdump'

##
# This controls word size
# in  16-bit  real  mode,  a word refers to a 16-bit value
# in 32-bit protected mode, a word refers to a 32-bit value
# short,int, and long, which usually represent
# 16-bit, 32-bit, and 64-bit values, respectively.
# 8 bit values are named bytes, 2 hex chars per byte, 4 hex chars in 16 bits.
MODES = {
  16 => :'16_BIT_REAL',
  32 => :'32_BIT_PROECTED'
}.freeze

module BaseAsm
  attr_reader :instructions, :symbols, :mode

  module ClassMethods
    def build(&block)
      new.build(&block)
    end
  end

  module InstanceMethods
    def initialize(mode: MODES[16])
      @mode = mode
      @symbols = {}
      @instructions = []
    end

    def buffer
      instructions.join
    end

    def build(&block)
      instance_eval(&block)
      self
    end

    # position of last instruction in decimal?
    def cursor
      buffer.length
    end

    # `hexdump <file>` - but on a string of hex
    def to_s
      Hexdump.new(buffer, word_size: 4).to_s
    end

    # `od -t x1 -A n <file>` - but on a string of hex
    def hexdump(by: 2)
      Hexdump.new(buffer, word_size: by).to_s
    end
  end

  def self.included(reciever)
    reciever.extend         ClassMethods
    reciever.send :include, InstanceMethods
  end
end
