require 'skr/core/db/migration_helpers'

class CreateSkrUsers < ActiveRecord::Migration
    def change
        create_skr_table "users" do | t |
            t.string :login, :name, :email,  null: false

            t.string :password_digest, null: false
            t.string  "role_names",   array: true, null:false, default: []
            t.hstore "options",       null: false, default:  {}
            t.skr_track_modifications
        end

        skr_add_index  :users, :role_names, using: 'gin'

    end
end
