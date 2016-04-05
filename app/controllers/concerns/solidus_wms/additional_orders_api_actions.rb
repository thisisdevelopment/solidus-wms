module SolidusWms
  module AdditionalOrdersApiActions
    extend ActiveSupport::Concern

    def export
      authorize! :update, @order, params[:token]
      @order.export!
      respond_with(@order, default_template: :show)
    end

    def to_export
      authorize! :index, Order
      @orders = Order.to_export(params[:completed_at])
      respond_with(@orders)
    end
  end
end


