Given /^the server is running$/ do
  @_server ||= Server.new
  in_current_dir { @_server.start }
end

Given /^the server is running with this config:$/ do |config|
  write_file DEFAULT_CONFIG_PATH, config
  @_server = Server.new
  in_current_dir { @_server.start }
end


When /^I stop the server$/ do
  @_server.stop
end

When /^I request "([^"]*)"$/ do |path|
  @response = HTTParty.get(@_server.uri_for_path path)
end

When /^I send the SIGINT signal$/ do
  @_server.sig_int
end


Then /^the server must stop successfully$/ do
  expect(@_server.wait_stop).to be true
  expect(@_server.exit_status).to eq 0
end

Then /^the rack handler must be "([^"]*)"$/ do |handler|
  @_server.stop
  expect(@_server.stdout + @_server.stderr).to match /#{handler}/i
end

Then /^the response status must be (\d+)$/ do |status|
  expect(@response.code).to eq status.to_i
end

Then /^the body must be "([^"]*)"$/ do |body|
  expect(@response.body).to eq body.gsub('\n', "\n")
end

Then /^the server output must match \/(.*)\/$/ do |pattern|
  @_server.stop
  expect(@_server.stdout + @_server.stderr).to match Regexp.compile(pattern)
end
