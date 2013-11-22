Then /^the manifest should include build path for "([^"]*)"$/ do |path|
  prep_for_fs_check do
    manifest = JSON.parse(IO.read('public/assets/manifest.json'))
    built_path_pattern = path.gsub '.', '-[0-9a-f]+\.'
    manifest['assets'][path].should =~ Regexp.compile(built_path_pattern)
  end
end
