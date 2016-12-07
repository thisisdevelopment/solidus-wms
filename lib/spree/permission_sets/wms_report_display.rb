module Spree
  module PermissionSets
    class WmsReportDisplay < PermissionSets::Base
      def activate!
        can [:display, :admin, :unexported_orders], :reports
      end
    end
  end
end
