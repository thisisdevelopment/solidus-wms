module SolidusWms
  module AdditionalShipmentsApiActions
    extend ActiveSupport::Concern

    included do
      alias_method :wms_lock_order, :lock_order

      skip_around_filter :lock_order, only: [:pick, :receive]
      before_filter :wms_find_shipment, only: [:pick, :receive]
      around_filter :wms_lock_order, only: [:pick, :receive]
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

    def wms_find_shipment
      find_shipment
    end
  end
end
