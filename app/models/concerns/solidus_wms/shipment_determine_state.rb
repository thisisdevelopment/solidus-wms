module SolidusWms
  module ShipmentDetermineState
    extend ActiveSupport::Concern

    def determine_state(order)
      return 'picked' if state == 'picked'
      return 'received' if state == 'received'

      super
    end
  end
end
