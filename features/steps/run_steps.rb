When(/^I successfully run `([^`]+)`$/) do |command|
  run_simple Aruba::Platform.unescape(command, aruba.config.keep_ansi), true
end

When(/^I run `([^`]+)`$/) do |command|
  run_simple Aruba::Platform.unescape(command, aruba.config.keep_ansi), false
end
