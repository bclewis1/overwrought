module Test
  module_function

  def fixture(path)
    File.join(__dir__, 'fixtures', path)
  end
end
