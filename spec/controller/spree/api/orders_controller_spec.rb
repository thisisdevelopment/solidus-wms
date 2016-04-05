describe Spree::Api::OrdersController, type: :controller do
  render_views

  let!(:order) { create(:order_ready_to_ship) }

  before do
    include ApiControllerMethods

    allow_any_instance_of(Spree::Ability).to receive(:can?).
      and_return(true)

    allow_any_instance_of(Spree::Ability).to receive(:can?).
      with(:admin, Spree::Order).
      and_return(true)

    stub_authentication!
  end

  it 'will export an order' do
    api_put(:export, id: order.to_param)

    order.reload

    expect(response.status).to eq(200)

    expect(order.exported?).to be true
  end

  context 'when the order is incomplete' do
    let!(:order) { create(:order) }

    it 'will not export an order' do
      api_put(:export, id: order.to_param)

      expect(response.status).to eq 422

      expect(order.exported?).to be false
    end
  end
end
