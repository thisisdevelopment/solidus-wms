require 'axlsx'

module SolidusWms
  module AdditionalOrdersActions
    extend ActiveSupport::Concern

    included do
      before_filter :authenticate_basic_auth, only: [:export_xlsx]
    end

    def export_xlsx
      exporter = Wms::OrderExporter.new(Spree::WmsConfig.order_xls_export_class.new)
      exporter.export_xlsx(Wms::AttachmentMailer.new)
      render nothing: true
    end

    private

    def authenticate_basic_auth
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV.fetch('HTTP_AUTH_USER') && password == ENV.fetch('HTTP_AUTH_PASS')
      end
    end
  end
end
