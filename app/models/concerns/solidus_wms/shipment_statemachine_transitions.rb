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

        after_transition to: [:received, :picked, :shipped], do: :update_order_shipment_state
        after_transition to: :received, do: :mark_received
      end
    end

    def can_transition_from_ready_to_shipped?
      !order.exported?
    end

    def mark_received
      touch :received_at
    end

    def update_order_shipment_state
      update!(order)
      order.updater.update_shipment_state
      order.updater.run_hooks
      order.updater.persist_totals
    end
  end
end
