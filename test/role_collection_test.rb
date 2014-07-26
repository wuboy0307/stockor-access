require_relative 'test_helper'
require 'skr/access'

class RoleCollectionTest < Skr::TestCase

    def setup
        @user = Skr::User.new( login: 'test', email: 'bob@test.com', name: 'Bob', password: 'testtest')
    end

    def test_can_read
        @user.role_names = ['customer_support']
        assert_saves @user
        assert @user.can_read?(Skr::Customer), "User with CustomerSupport role cannot read Customer"
    end
end
