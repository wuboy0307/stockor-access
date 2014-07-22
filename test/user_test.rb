require_relative 'test_helper'
require 'skr/access'

class UserTest < Skr::TestCase

    def setup
        @user = Skr::User.new( login: 'test', email: 'bob@test.com', name: 'Bob', password: 'testtest')
    end

    def test_validations
        user = Skr::User.new
        refute_saves user, 'login'
        user.assign_attributes login: 'test', email: 'bob', name: 'Bob'
        refute_saves user, 'email'
        user.email = 'bob@test.com'
        refute_saves user, 'password'
        user.password = 'password'
        assert_saves user
    end

    def test_roles
        @user.role_names = ['administrator']
        assert_saves @user
        assert_equal [ 'administrator' ], @user.role_names
        assert_equal [ :administrator  ], @user.roles.to_sym
    end


end
