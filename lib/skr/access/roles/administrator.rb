module Skr
    module Access

        module Roles

            class Administrator < Role
                self.grant( Skr::Model.descendants )
            end

        end

    end
end
