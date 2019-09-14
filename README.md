# IRIS (Introspective, Resilient Information System)

An attempt a writing an OS primarily in Ruby with some bash scripting and Debian (Ubuntu) commands thrown in as needed.

# Install (on Ubuntu 19.04)
To test install qemu
- `sudo apt install qemu-kvm qemu nasm`
- `echo "export RUBYGEMS_GEMDEPS=-" >> ~/.bashrc`
- `source ~/.bashrc`
- `bundle install`

# Usage
1. `chmod +x bin/*`
2. `bin/build_boot_sector.rb`

> WARNING this command could be very destructive!!!
3. `bin/write_load_boot_sector.rb`

# Testing
- `guard` - in theory this uses the bundled version and watches your files
for changes dynamically.
- `bin/nasm.rb` - compiles the code in `scratchpad.asm` using the Nasm assembler. This is helpful for testing the results of specific commands during development.

# Resources
- https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
- http://mikeos.sourceforge.net/write-your-own-os.html
- https://c9x.me/x86/
- http://www.mathemainzel.info/files/x86asmref.html
- http://ref.x86asm.net/
- https://www.sandpile.org/
- https://www.nasm.us/xdoc/2.13.01/nasmdoc.pdf
