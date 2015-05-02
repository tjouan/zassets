Then /^the output must contain "([^"]+)"$/ do |content|
  expect(all_output).to include  content
end

Then /^the output must contain:$/ do |content|
  expect(all_output).to include  content
end

Then /^the output must match \/([^\/]+)\/([a-z]*)$/ do |pattern, options|
  expect(all_output).to match Regexp.new(pattern, options)
end
