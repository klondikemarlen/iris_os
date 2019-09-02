#!/usr/bin/env ruby
# frozen_string_literal: true

require './lib/hex_file'

boot_sector = 'dist/boot_sect.bin'

HexFile.write boot_sector do
  'e9 fd ff 00' + '00' * (512 - 6) + '55 aa'
end

data = HexFile.read boot_sector
puts data
puts "File size: #{data.length / 2}"
puts "File size: #{HexFile.last_read_size}"

puts 'Now run bin/write_load_boot_sector.rb'
