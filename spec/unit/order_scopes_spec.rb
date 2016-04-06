describe Spree::Order do
  let!(:order) { create(:order_ready_to_ship) }

  context '#not_exported' do
    subject { described_class.not_exported }

    it { is_expected.to_not be_empty }

    context 'when the order is exported' do
      before { order.export! }

      it { is_expected.to be_empty }
    end
  end

  context '#exported' do
    subject { described_class.exported }

    it { is_expected.to be_empty }

    context 'when the order is exported' do
      before { order.export! }

      it { is_expected.to_not be_empty }
    end
  end

  context '#to_export' do
    let(:date) { Time.now - 1.day }
    let!(:other_order) { create(:order_ready_to_ship) }

    before do
      other_order.update_column(:completed_at, date - 1.day)
    end

    subject { described_class.to_export(date).count }

    it { is_expected.to eq 1 }

    context 'when all orders exported' do
      before do
        order.update_column(:exported_at, date)
        other_order.update_column(:exported_at, date)
      end

      it { is_expected.to be_zero }
    end
  end
end
