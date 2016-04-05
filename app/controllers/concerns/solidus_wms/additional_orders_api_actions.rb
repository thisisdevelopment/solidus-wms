module SolidusWms
  module AdditionalOrdersApiActions
    extend ActiveSupport::Concern

    included do
      skip_before_action :find_order, only: [:to_export]
      skip_filter :lock_order, only: [:to_export]
    end

    def export
      authorize! :update, @order, params[:token]
      @order.export!
      respond_with(@order, default_template: :show)
    end

    def to_export
      authorize! :index, Spree::Order
      @orders = Spree::Order.to_export(params[:completed_at])
      respond_with(@orders, default_template: :to_export)
    end
  end
end
