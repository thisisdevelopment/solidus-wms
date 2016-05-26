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
    let(:primary_store) { create(:store) }

    context "caching enabled" do
      before do
        ActionController::Base.perform_caching = true
        3.times do
          order = create(:order_ready_to_ship, store_id: primary_store.id)
          order.update_columns(completed_at: (from_time - 10.minutes))
        end
      end

      it "returns unique orders" do
        api_get(:to_export, completed_before: from_time)

        orders = json_response[:orders]
        expect(orders.count).to eq 3
        expect(orders.map { |o| o[:id] }).to match_array Spree::Order.pluck(:id)
      end

      after { ActionController::Base.perform_caching = false }
    end

    context 'with multiple stores' do
      let(:secondary_store) { create(:store) }

      let!(:order) { create(:order_ready_to_ship, store_id: primary_store.id) }
      let!(:another_order) { create(:order_ready_to_ship, store_id: secondary_store.id) }

      let(:request) { @request }

      before do
        order.update_columns(completed_at: (from_time - 10.minutes))
        another_order.update_columns(completed_at: (from_time - 10.minutes))
      end

      it "returns orders for primary_store" do
        request.host = primary_store.url
        api_get(:to_export, completed_before: from_time)

        expect(json_response[:orders].count).to eq 1
        order_ids = json_response[:orders].map { |o| o[:id] }

        expect(order_ids).to include(order.id)
        expect(order_ids).not_to include(another_order.id)
      end
    end
  end
end
