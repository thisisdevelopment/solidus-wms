module SolidusWms
  module ShipmentStatemachineTransitions
    extend ActiveSupport::Concern

    included do
      state_machine do
        event :receive do
          transition from: :ready, to: :received
        end

        event :pick do
          transition from: :received, to: :picked
        end

        event :ship do
          reset

          transition from: [:ready], to: :shipped, if: :can_transition_from_ready_to_shipped?
          transition from: [:canceled, :picked], to: :shipped
        end
      end
    end

    def can_transition_from_ready_to_shipped?
      !order.exported?
    end
  end
end
