module Skr
    module Access
        module Roles

            class Purchasing < Role
                self.grant Vendor, PurchaseOrder
                self.read << Customer
            end

        end
    end
end
