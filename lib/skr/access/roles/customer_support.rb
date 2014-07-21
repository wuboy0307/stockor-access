module Skr
    module Access

        module Roles

            class CustomerSupport < Role
                self.grant Customer, SalesOrder, Invoice
                self.read += [ PurchaseOrder, Vendor ]
            end

        end

    end
end
