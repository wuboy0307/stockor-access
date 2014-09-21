require 'skr/core'
require 'skr/core/db/migrations'

module Skr
  module Access
      # add our migrations to the generator
      Skr::Core::DB::Migrations.paths << Pathname.new(__FILE__).dirname.join("../../db/migrate").realpath

      class << self

          def _type_to_str(klass)
              klass.to_s.demodulize.underscore
          end

          def for_user( user )
              {
                  :roles => user.roles.map{ | role |
                      {
                          type: _type_to_str(role.class),
                          read: role.read.map{ |klass| _type_to_str(klass) },
                          write: role.write.map{ |klass| _type_to_str(klass) },
                          delete: role.delete.map{ |klass| _type_to_str(klass) }
                      }
                  },
                  :locked_fields => LockedFields.definitions.map{ | klass, locks |
                      {
                          type: _type_to_str(klass),
                          locks: locks.each_with_object({}) do |(field, grants), result|
                              result[field] = grants.map do |grant|
                                  { role: _type_to_str(grant[:role]), only: grant[:only] }
                              end
                          end
                      }
                  }
              }
          end

      end
  end
end

require_relative 'access/locked_fields'
require_relative 'access/role'
require_relative 'access/role_collection'
require_relative 'access/global_grants'

require_relative 'access/api_authentication_provider'
require_relative 'user'
require_relative 'access/users_controller'

if Skr.const_defined?('Workspace')
    require_relative 'access/workspace_screen'
    require_relative 'access/workspace_extension'
end
