Given /^this config file:$/ do |config|
  write_file DEFAULT_CONFIG_PATH, config
end


Then /^it must fail to parse the config$/ do
  expect(all_output).to match /yaml.+error/i
end
