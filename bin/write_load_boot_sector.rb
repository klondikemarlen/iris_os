#!/usr/bin/env ruby
# frozen_string_literal: true

# requires drive to be partitioned as fat32 in gparted with boot flag set
drive = '/dev/sdc'

# write to drive
puts 'Write command, please verify drive.'
`sudo dd if=#{boot_sector} of=#{drive} bs=512 count=1`

# Write boot sector
`sudo dd if=dist/boot_sect.bin of=/dev/sdc1 bs=512`

# boot after install
`sudo qemu-system-x86_64 -hdb /dev/sdc`

# possibly interesting
# qemu-system-i386 -drive format=raw,file=dist/os.img
