require_relative 'test_helper'
require 'skr/access'

class LockedFieldsTest < Skr::TestCase

    def setup
        @user = Skr::User.new( login: 'test', email: 'bob@test.com', name: 'Bob', password: 'testtest')
    end

    def test_validations
        @user.role_names = ['customer_support']
        assert_saves @user
        assert @user.can_read?(Skr::Customer)
        assert @user.can_write?(Skr::Customer)
        refute @user.can_write?(Skr::Customer, :terms_id)
    end


end
