describe Wms::OrderExporter do
  let(:spreadsheet_exporter) { spy(worksheets: []) }

  it 'fires the #on_success callback' do
    described_class.new(spreadsheet_exporter).export_xlsx(double.as_null_object)
    expect(spreadsheet_exporter).to have_received(:on_success)
  end
end
