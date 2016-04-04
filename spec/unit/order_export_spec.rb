describe Spree::Order do
  let!(:order) { create(:order_ready_to_ship) }

  subject { order.exported? }

  it { is_expected.to be false }

  context 'when the order is exported' do
    before do
      order.export
    end

    it { is_expected.to be true }
  end
end
