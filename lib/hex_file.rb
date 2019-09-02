# frozen_string_literal: true

require 'pry'

class HexFile
  class << self
    attr_reader :last_read_size
  end

  @last_read_size = nil

  def self.read(path)
    data = ''
    File.open(path, 'rb') do |f|
      data = f.read.unpack('H*')[0].to_s
    end
    @last_read_size = (data.length / 2)
    fix_ordering data
  end

  def self.write(path)
    pack_safe_data = pack_safe yield
    File.open(path, 'wb') do |f|
      f.write([pack_safe_data].pack('H*'))
    end
  end

  def self.pack_safe(data)
    without_spaces = data.split.join
    swapped = without_spaces.scan(/.{1,4}/).map do |chars|
      "#{chars[2..4]}#{chars[0..1]}"
    end
    swapped.join
  end

  def self.fix_ordering(data)
    swapped = data.scan(/.{1,4}/).map do |chars|
      "#{chars[2..4]}#{chars[0..1]}"
    end
    swapped.join ' '
  end
end
