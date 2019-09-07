#!/usr/bin/env ruby
# frozen_string_literal: true

# requires drive to be partitioned as fat32 in gparted with boot flag set
boot_sector = 'dist/boot_sect.bin'
drive = '/dev/sdc'

puts 'To get correct drive name do `lsblk`'
puts 'To remove drive do `udisksctl unmount -b /dev/sdc1 && udisksctl power-off -b /dev/sdc`'

# Write boot sector to drive
puts 'Write command, please verify drive.'
`sudo dd if=#{boot_sector} of=#{drive} bs=512 count=1`

# boot after install
# `sudo qemu-system-x86_64 -hdb #{drive}`
`sudo qemu-system-i386 -hdb #{drive}`

# possibly interesting
# qemu-system-i386 -drive format=raw,file=dist/os.img
