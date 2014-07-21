module Skr
    module Access
        module Roles

            class Purchasing < Role
                self.grant Vendor, PurchaseOrder
            end

        end
    end
end
