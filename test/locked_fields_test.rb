require_relative 'test_helper'
require 'skr/access'

class LockedFieldsTest < Skr::TestCase

    def setup
        @user = Skr::User.new( login: 'test', email: 'bob@test.com', name: 'Bob', password: 'testtest')
        @purchaser = Skr::User.new( login: 'test', email: 'bob@test.com', name: 'Bob', password: 'testtest')

    end

    def test_validations
        @user.role_names = ['customer_support']
        @purchaser.role_names = ['purchasing']
        assert_saves @user
        assert @user.can_read?(  Skr::Customer), "User with CustomerSupport role cannot read Customer"
        assert @user.can_write?( Skr::Customer)
        refute @purchaser.can_read?(  Skr::Customer)

        refute @user.can_write?( Skr::Customer, :terms_id)
        assert @user.can_read?(  Skr::Customer, :terms_id)
        refute @purchaser.can_read?(  Skr::Customer, :terms_id)
    end


end
