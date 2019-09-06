# frozen_string_literal: true

# Currently just a placeholder.
# Later this wil controll word size
# in  16-bit  real  mode,  aword refers to a 16-bit value
# in 32-bit protected mode, awordrefers to a 32-bit value
# short,int, and long, which usually represent
# 16-bit, 32-bit, and 64-bit values, respectively.
# 8 bit values, which are named bytes
# 2 hex chars per byte, 4 hex chars in 16 bits.
MODES = {
  16 => :'16_BIT_REAL',
  32 => :'32_BIT_PROECTED'
}.freeze

module BaseAsm
  attr_reader :instructions, :symbols

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

    def to_s
      hide_output = false
      first = true
      out = buffer.scan(/.{1,32}/).map do |line|
        next if line.match(/^0*$/) && hide_output && !first

        if line.match(/^0*$/)
          if first
            first = false
            line.scan(/.{1,2}/).map { |c| "#{c} " }.join[0..-1].rstrip
          else
            hide_output = true
            '*'
          end
        else
          hide_output = false
          line.scan(/.{1,2}/).map { |c| "#{c} " }.join[0..-1].rstrip
        end
      end
      out = out.compact
      multi_line = out.length > 1
      out = out.join("\n")
      out += "\n" if multi_line
      out
    end
  end

  def self.included(reciever)
    reciever.extend         ClassMethods
    reciever.send :include, InstanceMethods
  end
end
