When /^I build$/  do
  run_simple 'zassets build'
end


Then /^the built file "([^"]*)" must exist$/ do |path|
  prep_for_fs_check do
    Dir[path].any?.should == true
  end
end

Then /^the built file "([^"]*)" must contain "([^"]*)"$/ do |path, content|
  prep_for_fs_check do
    IO.read(Dir[path].first).should include(content)
  end
end

Then /^the built file "([^"]*)" must match:/ do |path, content|
  regexp = Regexp.compile(content, Regexp::EXTENDED)
  prep_for_fs_check do
    IO.read(Dir[path].first).should =~ regexp
  end
end

Then /^the built file "([^"]*)" must match \/([^\/]*)\/$/ do |path, content|
  regexp = Regexp.compile(content)
  prep_for_fs_check do
    IO.read(Dir[path].first).should =~ regexp
  end
end

Then /^it must build$/ do
  prep_for_fs_check do
    File.exist?('public/assets/manifest.json').should be_truthy
  end
end
