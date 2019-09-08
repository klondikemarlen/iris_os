#!/usr/bin/env ruby
# frozen_string_literal: true

drive = '/dev/sdc'
`udisksctl unmount -b #{drive}1`
`udisksctl power-off -b #{drive}`
