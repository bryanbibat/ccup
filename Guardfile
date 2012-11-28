# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', cli: "--color --format nested" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/ccup/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  watch(%r{^lib/ccup/(.+)\.rb$})     { |m| "spec/ccup/#{m[1]}_spec.rb" }
end

