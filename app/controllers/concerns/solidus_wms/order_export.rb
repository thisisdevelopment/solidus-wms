module SolidusWms
  module OrderExport
    extend ActiveSupport::Concern

    def export
      authorize! :update, @order, params[:token]
      @order.export!
      respond_with(@order, default_template: :show, version: 1)
    end
  end
end
