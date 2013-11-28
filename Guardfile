guard :cucumber, cli: '--format pretty --quiet' do
  watch(%r{\Afeatures/.+\.feature\z})
  watch(%r{\Afeatures/support/.+\.rb\z})                { 'features' }
  watch(%r{\Afeatures/step_definitions/.+_steps\.rb\z}) { 'features' }
end

guard :rspec do
  watch(%r{\Aspec/.+_spec\.rb\z})
  watch(%r{\Alib/(.+)\.rb\z})         { |m| "spec/#{m[1]}_spec.rb" }

  watch(%r{\Aspec/support/.+\.rb\z})  { 'spec' }
end
