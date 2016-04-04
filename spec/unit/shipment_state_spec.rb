describe Spree::Shipment do
  let!(:order) { create(:order_ready_to_ship) }

  let(:shipment) { order.shipments.first }

  subject { shipment.state }

  context 'when the shipment is pending' do
    before do
      shipment.receive!
    end

    it { is_expected.to eq('received') }

    context 'when the shipment has been received' do
      before do
        shipment.pick!
      end

      it { is_expected.to eq('picked') }

      context 'when the shipment has been picked' do
        before do
          shipment.ship!
        end

        it { is_expected.to eq('shipped') }
      end
    end
  end

  context 'when the order has been exported' do
    subject do
      -> { shipment.ship! }
    end

    before { shipment.order.export! }

    it { is_expected.to raise_error(StateMachines::InvalidTransition) }
  end
end
