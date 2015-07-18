def glob pattern
  cd('.') { Dir[pattern].first }
end


When /^I build$/  do
  run_simple 'zassets build'
end


Then /^the built file "([^"]*)" must exist$/ do |path|
  expect(glob path).to be_an_existing_file
end

Then /^the built file "([^"]*)" must contain "([^"]*)"$/ do |path, content|
  expect(glob path).to have_file_content Regexp.new(content)
end

Then /^the built file "([^"]*)" must match:/ do |path, content|
  expect(glob path)
    .to have_file_content Regexp.compile(content, Regexp::EXTENDED)
end

Then /^the built file "([^"]*)" must match \/([^\/]*)\/$/ do |path, content|
  expect(glob path)
    .to have_file_content Regexp.compile(content)
end

Then /^it must build$/ do
  expect('public/assets/manifest.json').to be_an_existing_file
end
