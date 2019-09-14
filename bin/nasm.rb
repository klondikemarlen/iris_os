#!/usr/bin/env ruby
# frozen_string_literal: true

file = ARGV[0] || 'scratchpad'

`nasm #{file}.asm -f bin -o tmp/#{file}.bin`
puts
puts '`hexdump` of compiled file:'
puts `hexdump tmp/#{file}.bin`
puts
puts 'Alternate dump from `od`'
puts `od -t x1 -A n tmp/#{file}.bin`
puts
