module FixturesHelpers
  FIXTURE_PATH = File.join(File.dirname(__FILE__), '..', 'fixtures')

  def fixture_path_for(path)
    File.join(FIXTURE_PATH, path)
  end

  def within_fixture_path
    Dir.chdir FIXTURE_PATH do
      yield
    end
  end
end
