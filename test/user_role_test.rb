require_relative 'test_helper'
require 'skr/access'

class UserRoleTest < Skr::TestCase

    def setup
        @support = Skr::User.new( login: 'test', email: 'support@test.com', name: 'Bob',
          password: 'testtest', role_names:['support'])
        @admin = Skr::User.new( login: 'test', email: 'admin@test.com', name: 'Bob',
          password: 'testtest', role_names:['admin'])
    end

    def test_grants
        assert @admin.can_read?(@support)
        refute @support.can_create?(@admin)
    end

end
