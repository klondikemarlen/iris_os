#!/usr/bin/env ruby
# frozen_string_literal: true

require './lib/asm'
require './lib/hex_file'

boot_sector = 'dist/boot_sect.bin'

# 'e9fdff00'.ljust(510) + '55aa'
# 'e9 fd ff 00' + '00' * (512 - 6) + '55 aa'
asm = Asm.build do
  label :loop do
    jmp :loop
  end
  pad 510, 0
  dw 0xaa55
end

HexFile.write boot_sector do
  asm.buffer
end

data = HexFile.read boot_sector
puts data
puts "File size: #{HexFile.last_read_size}"

puts 'Now run bin/write_load_boot_sector.rb'
