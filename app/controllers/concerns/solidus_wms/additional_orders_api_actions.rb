module SolidusWms
  module AdditionalOrdersApiActions
    extend ActiveSupport::Concern

    included do
      skip_before_action :find_order, only: [:to_export]
      skip_around_action :lock_order, only: [:to_export]
    end

    def export
      authorize! :update, @order, params[:token]
      @order.export!
      respond_with(@order, default_template: :show)
    end

    def to_export
      authorize! :index, Spree::Order
      @orders = Spree::Order.by_store(current_store).to_export(params[:completed_before])
      respond_with(@orders, default_template: :to_export)
    end
  end
end
