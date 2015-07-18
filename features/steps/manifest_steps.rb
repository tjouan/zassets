Then /^the manifest must include build path for "([^"]*)"$/ do |path|
  cd '.' do
    manifest = JSON.parse(IO.read('public/assets/manifest.json'))
    built_path_pattern = path.gsub '.', '-[0-9a-f]+\.'
    expect(manifest['assets'][path]).to match Regexp.compile(built_path_pattern)
  end
end
