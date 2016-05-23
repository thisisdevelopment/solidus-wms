describe Spree::Api::ShipmentsController, type: :controller do
  render_views

  let(:shipment) { order.shipments.first }

  let!(:order) { create(:order_ready_to_ship) }
  let!(:current_api_user) do
    stub_model(Spree::LegacyUser, spree_roles: [Spree::Role.new(name: 'admin')])
  end

  subject { shipment.state }

  before do
    allow_any_instance_of(Spree::Ability).to receive(:can?).
      and_return(true)

    allow_any_instance_of(Spree::Ability).to receive(:can?).
      with(:admin, Spree::Shipment).
      and_return(true)

    stub_authentication!
    order.export!
  end

  context 'will mark a shipment as received' do
    before do
      api_put :receive, id: shipment.to_param

      reload_order_and_shipment
    end

    it { is_expected.to eq 'received' }

    it 'also updates order shipment state' do
      expect(order.shipment_state).to eq('received')
    end

    context 'then will mark a shipment as picked' do
      before do
        api_put :pick, id: shipment.to_param

        reload_order_and_shipment
      end

      it { is_expected.to eq 'picked' }

      it 'also updates order shipment state' do
        expect(order.shipment_state).to eq('picked')
      end

      context 'then will ship a picked shipment' do
        before do
          api_put :ship, id: shipment.to_param, send_mailer: nil

          reload_order_and_shipment
        end

        it { is_expected.to eq 'shipped' }

        it 'also updates order shipment state' do
          expect(order.shipment_state).to eq('shipped')
        end
      end
    end
  end

  def reload_order_and_shipment
    shipment.reload
    order.reload
  end
end
