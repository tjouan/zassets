guard 'rspec' do
  watch(%r{\Aspec/.+_spec\.rb\z})
  watch(%r{\Alib/(.+)\.rb\z}) { |m| "spec/#{m[1]}_spec.rb" }
end
