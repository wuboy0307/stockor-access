module Skr
    module Access

        module Roles

            class Accounting < Role
                self.grant GlAccount, GlManualEntry, GlPosting, GlTransaction
                self.read << GlPeriod

                lock_writes Customer, :terms_id
            end
        end

        #LockedFields.lock Customer, :terms_id, to: Accounting, only: :write

        # module Customer

        #     def json_attribute_is_allowed?( name, user )
        #         if name == :gl_receivables_account_id
        #             user.roles
        #         else
        #             super
        #         end
        #     end
        # end
        # Skr::Customer.send :extend, Customer

    end
end
