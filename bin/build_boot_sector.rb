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

doc = <<~DOC
  Read from Asm buffer (prettified):
  #{BOOT_SECT.hexdump}

    File size: #{BOOT_SECT.buffer.length / 2}

  Read from raw file data (via HexFile.read):
  #{HexFile.read out_file}

    File size: #{HexFile.last_read_size}

  Now run bin/write_load_boot_sector.rb
DOC
puts doc
