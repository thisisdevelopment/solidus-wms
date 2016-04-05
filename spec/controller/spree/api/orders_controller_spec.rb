describe Spree::Api::OrdersController, type: :controller do
  render_views

  before do
    allow_any_instance_of(Spree::Ability).to receive(:can?).
      and_return(true)

    allow_any_instance_of(Spree::Ability).to receive(:can?).
      with(:admin, Spree::Order).
      and_return(true)

    stub_authentication!
  end

  context '#export' do
    let!(:order) { create(:order_ready_to_ship) }

    it 'will export an order' do
      api_put(:export, id: order.to_param, api_version: 1)

      order.reload

      expect(response.status).to eq(200)

      expect(order.exported?).to be true
    end

    context 'when the order is incomplete' do
      let!(:order) { create(:order) }

      it 'will not export an order' do
        api_put(:export, id: order.to_param, api_version: 1)

        expect(response.status).to eq 422

        expect(order.exported?).to be false
      end
    end
  end

  context '#to_export' do
    let!(:from_time) { Time.now - 1.day }

    context "caching enabled" do
      before do
        ActionController::Base.perform_caching = true
        3.times do
          order = create(:order_ready_to_ship)
          order.update_columns(completed_at: Time.now)
        end
      end

      it "returns unique orders" do
        api_get(:to_export, completed_at: from_time)

        orders = json_response[:orders]
        expect(orders.count).to eq 3
        expect(orders.map { |o| o[:id] }).to match_array Spree::Order.pluck(:id)
      end

      after { ActionController::Base.perform_caching = false }
    end
  end
end
