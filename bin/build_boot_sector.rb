#!/usr/bin/env ruby
# frozen_string_literal: true

require './boot_sector'
require './lib/hex_file'

out_file = 'dist/boot_sect.bin'

# 'e9fdff00'.ljust(510) + '55aa'
# 'e9 fd ff 00' + '00' * (512 - 6) + '55 aa'

HexFile.write out_file do
  BOOT_SECT.buffer
end

data = HexFile.read out_file
puts data
puts "File size: #{HexFile.last_read_size}"

puts 'Now run bin/write_load_boot_sector.rb'
