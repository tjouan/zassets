Given /^this config file:$/ do |config|
  write_file DEFAULT_CONFIG_PATH, config
end


Then /^it must fail to parse the config$/ do
  all_output.should =~ /yaml.+error/i
end
