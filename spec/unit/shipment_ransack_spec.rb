describe Spree::Shipment do
  subject { described_class.whitelisted_ransackable_attributes }

  it { is_expected.to include('state') }
  it { is_expected.to include('created_at') }
end
