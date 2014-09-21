module Skr
    module Access

        module Roles

            class Accounting < Role
                self.grant GlAccount, GlManualEntry, GlPosting, GlTransaction
                self.grant Customer, PaymentTerm
                self.read << GlPeriod

                lock_writes Customer, :terms_id
            end

        end

    end
end
