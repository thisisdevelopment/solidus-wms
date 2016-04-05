module SolidusWms
  module AdditionalShipmentsApiActions
    extend ActiveSupport::Concern

    included do
      prepend_before_filter :more_find_shipment, only: [:pick, :receive]
    end

    def pick
      authorize! :ship, @shipment
      unless @shipment.picked?
        @shipment.pick!
      end
      respond_with(@shipment, default_template: :show)
    end

    def receive
      authorize! :ship, @shipment
      unless @shipment.received?
        @shipment.receive!
      end
      respond_with(@shipment, default_template: :show)
    end

    private

    def more_find_shipment
      find_shipment
    end
  end
end
