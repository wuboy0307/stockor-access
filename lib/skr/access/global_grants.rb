module Skr
    module Access

        Role.grant_global_access(Address)
        Role.grant_global_access(PaymentTerm, :read)

    end
end
