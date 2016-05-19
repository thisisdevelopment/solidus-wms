describe Spree::Shipment do
  let!(:order) { create(:order_ready_to_ship) }

  let(:shipment) { order.shipments.first }

  subject { shipment.state }

  context 'when the shipment is received' do
    before do
      shipment.receive!
    end

    it { is_expected.to eq('received') }

    it 'also updates order shipment state' do
      expect(order.shipment_state).to eq('received')
    end

    context 'when the shipment has been picked' do
      before do
        shipment.pick!
      end

      it { is_expected.to eq('picked') }

      it 'also updates order shipment state' do
        expect(order.shipment_state).to eq('picked')
      end

      context 'when the shipment has been shipped' do
        before do
          shipment.ship!
        end

        it { is_expected.to eq('shipped') }

        it 'also updates order shipment state' do
          expect(order.shipment_state).to eq('shipped')
        end

        it 'will send out a shipment mailer' do
          expect(ActionMailer::Base.deliveries).to_not be_empty
        end
      end
    end
  end

  context 'when the order has been exported' do
    before { shipment.order.export! }

    it { expect { shipment.ship! }.to raise_error(StateMachines::InvalidTransition) }
  end
end
