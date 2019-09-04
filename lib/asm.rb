# frozen_string_literal: true

require_relative 'asm_codes'
require_relative 'hex_file'
require_relative 'hexable'
require_relative 'interrupts'
require_relative 'jumps'
require_relative 'registers'

# TODO: make buffer squish spaces out
# and make it update the cursor position.

class Asm
  include Hexable
  include Interrupts
  include Jumps
  include Registers

  attr_reader :instructions, :symbols

  def initialize
    @symbols = {}
    @instructions = []
  end

  def build(&block)
    instance_eval(&block)
    self
  end

  def self.build(&block)
    new.build(&block)
  end

  def buffer
    instructions.join
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

  #######
  private
  #######

  def dw(value)
    hex = to_hex(value)
    @instructions << "#{hex[2..4]}#{hex[0..1]}"
  end

  def pad(size, char)
    @instructions << to_hex(char) * (size - buffer.length / 2)
  end
end
