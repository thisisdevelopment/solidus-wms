module Wms
  class OrderExporter
    def initialize(spreadsheet_exporter)
      @spreadsheet_exporter = spreadsheet_exporter
    end

    def export_xlsx(presenter)
      tempfile = Tempfile.new('spree_orders.xlsx')
      xlsx_file_contents.serialize(tempfile.path)
      presenter.present(tempfile.path)

      spreadsheet_exporter.try(:on_success)
    end

    private

    attr_reader :spreadsheet_exporter

    def xlsx_file_contents
      ::Axlsx::Package.new do |p|
        spreadsheet_exporter.worksheets.each do |order_group|
          p.workbook.add_worksheet(name: order_group.fetch(:name)) do |sheet|
            sheet.add_row order_group.fetch(:headers)

            order_group.fetch(:orders).each do |order|
              sheet.add_row order
            end
          end
        end
      end
    end
  end
end
