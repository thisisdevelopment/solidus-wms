require 'axlsx'

module SolidusWms
  module AdditionalOrdersActions
    extend ActiveSupport::Concern

    included do
      before_filter :authenticate_basic_auth, only: [:export_xlsx]
    end

    def export_xlsx
      exporter = Spree::WmsConfig.order_xls_export_class.new
      tempfile = Tempfile.new('spree_orders.xlsx')
      xlsx_file_contents(exporter).serialize(tempfile.path)
      Spree::WmsConfig.order_xls_export_mailer_class.latest(tempfile.path).deliver_now
      exporter.on_success

      render nothing: true
    end

    private

    def xlsx_file_contents(exporter)
      ::Axlsx::Package.new do |p|
        exporter.worksheets.each do |order_group|
          p.workbook.add_worksheet(name: order_group.fetch(:name)) do |sheet|
            sheet.add_row order_group.fetch(:headers)

            order_group.fetch(:orders).each do |order|
              sheet.add_row order
            end
          end
        end
      end
    end

    def authenticate_basic_auth
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV.fetch('HTTP_AUTH_USER') && password == ENV.fetch('HTTP_AUTH_PASS')
      end
    end
  end
end
