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
  @_server.wait_stop.should == true
  @_server.exit_status.should == 0
end

Then /^the rack handler must be "([^"]*)"$/ do |handler|
  @_server.stop
  output = @_server.stdout + @_server.stderr
  output.should match /#{handler}/i
end

Then /^the response status must be (\d+)$/ do |status|
  @response.code.should == status.to_i
end

Then /^the body must be "([^"]*)"$/ do |body|
  @response.body.should == body.gsub('\n', "\n")
end

Then /^the server output must match \/(.*)\/$/ do |pattern|
  @_server.stop
  output = @_server.stdout + @_server.stderr
  output.should =~ Regexp.compile(pattern)
end
