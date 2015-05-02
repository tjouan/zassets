When /^I build$/  do
  run_simple 'zassets build'
end


Then /^the built file "([^"]*)" must exist$/ do |path|
  prep_for_fs_check do
    expect(Dir[path].any?).to be true
  end
end

Then /^the built file "([^"]*)" must contain "([^"]*)"$/ do |path, content|
  prep_for_fs_check do
    expect(IO.read(Dir[path].first)).to include content
  end
end

Then /^the built file "([^"]*)" must match:/ do |path, content|
  regexp = Regexp.compile(content, Regexp::EXTENDED)
  prep_for_fs_check do
    expect(IO.read(Dir[path].first)).to match regexp
  end
end

Then /^the built file "([^"]*)" must match \/([^\/]*)\/$/ do |path, content|
  regexp = Regexp.compile(content)
  prep_for_fs_check do
    expect(IO.read(Dir[path].first)).to match regexp
  end
end

Then /^it must build$/ do
  prep_for_fs_check do
    expect(File.exist?('public/assets/manifest.json')).to be true
  end
end
