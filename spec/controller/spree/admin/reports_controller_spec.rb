describe Spree::Admin::ReportsController, type: :controller do
  render_views

  describe 'Register unexported orders report' do
    it 'should contain unexported_orders' do
      expect(Spree::Admin::ReportsController.available_reports.keys.include?(:unexported_orders)).to be true
    end

    it 'should have the proper description' do
      expect(Spree::Admin::ReportsController.available_reports[:unexported_orders][:description]).to eql(Spree.t(:unexported_orders_description))
    end
  end
end
