# frozen_string_literal: true

# or possibly cmd: 'bundle exec rspec'
guard :rspec, cmd: 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) do |m|
    "spec/lib/#{m[1]}_spec.rb"
  end
  watch('spec/spec_helper.rb') { 'spec' }
end
