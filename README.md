# IRIS (Introspective, Resilient Information System)

An attempt a writing an OS primarily in Ruby with some bash scripting and Debian (Ubuntu) commands thrown in as needed.

# Install
To test install qemu
`sudo apt-get install qemu-kvm qemu`

# Usage
1. `chmod +x bin/*`
2. `bin/build_boot_sector.rb`

> WARNING this command could be very destructive!!!
3. `bin/write_load_boot_sector.rb`

# Resources
- https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
- http://mikeos.sourceforge.net/write-your-own-os.html
