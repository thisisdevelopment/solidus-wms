require 'axlsx'

module SolidusWms
  module AdditionalOrdersActions
    extend ActiveSupport::Concern

    included do
      before_filter :authenticate_basic_auth, only: [:export_xlsx]
    end

    def export_xlsx
      exporter = Spree::WmsConfig.order_xls_export_class.new

      Mime::Type.register 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', :xlsx

      send_data(xlsx_file_contents(exporter).to_stream.string,
                type: Mime::XLSX,
                disposition: 'attachment; filename=orders.xlsx')
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
        username == ENV.fetch('WMS_BASIC_AUTH_USER') && password == ENV.fetch('WMS_BASIC_AUTH_PASS')
      end
    end
  end
end
