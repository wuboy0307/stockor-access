require 'skr/core'
require 'skr/core/db/migrations'

module Skr
  module Access
      # add our migrations to the generator
      Skr::Core::DB::Migrations.paths << Pathname.new(__FILE__).dirname.join("../../db/migrate").realpath
  end
end

require_relative 'access/locked_fields'
require_relative 'access/role'
require_relative 'access/role_collection'
require_relative 'access/serializer'
require_relative 'access/api_authentication_provider'
require_relative 'user'
require_relative 'access/users_controller'

if Skr.const_defined?('Workspace')
    require_relative 'access/workspace_screen'
    require_relative 'access/workspace_extension'
end
