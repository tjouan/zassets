When(/^I successfully run `([^`]+)`$/) do |command|
  run_simple unescape(command), true
end

When(/^I run `([^`]+)`$/) do |command|
  run_simple unescape(command), false
end
