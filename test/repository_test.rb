require 'minitest/autorun'
require 'minitest/pride'
require './lib/repository'

class RepositoryTest < Minitest::Test
  def test_it_exists_and_has_attributes
    repo = Repository.new

    assert_instance_of Repository, repo
  end
end
