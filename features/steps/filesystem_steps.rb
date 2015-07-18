Given /^a directory named "([^"]*)"$/ do |path|
  create_directory path
end

Given /^a file named "([^"]*)" with "([^"]*)"$/ do |path, content|
  write_file path, (content + "\n")
end

Given /^a file named "([^"]+)" with:$/ do |path, content|
  write_file path, (content + "\n")
end

Given /^an empty file named "([^"]*)"$/ do |path|
  write_file path, ''
end
