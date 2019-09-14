# frozen_string_literal: true

cls = 'tput reset'

# Note: The cmd option is now required due to the increasing number of ways
#       rspec may be run, below are examples of the most common uses.
#  * bundler: 'bundle exec rspec'
#  * bundler binstubs: 'bin/rspec'
#  * spring: 'bin/rspec' (This will use spring if running and you have
#                          installed the spring binstubs per the docs)
#  * zeus: 'zeus rspec' (requires the server to be started separately)
#  * 'just' rspec: 'rspec'

guard :rspec, cmd: "#{cls} && bundle exec rspec" do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  # Feel free to open issues for suggestions and improvements

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # or possibly cmd: 'bundle exec rspec'
  # guard :rspec, cmd: "#{cls} && bundle exec rspec" do
  #   watch(%r{^spec/.+_spec\.rb$})
  #   watch(%r{^lib/(.+)\.rb$}) do |m|
  #     "spec/lib/#{m[1]}_spec.rb"
  #   end
  #   watch('spec/spec_helper.rb') { 'spec' }
  # end
end
