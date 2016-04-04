describe Spree::Order do
  let!(:order) { create(:order_ready_to_ship) }

  context '#not_exported' do
    subject { described_classe.not_exported }

    it { is_expected.to_not be_empty }

    context 'when the order is exported' do
      it { is_expected.to be_empty }
    end
  end

  context '#exported' do
    subject { described_classe.exported }

    it { is_expected.to be_empty }

    context 'when the order is exported' do
      it { is_expected.to_not be_empty }
    end
  end
end
