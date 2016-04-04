describe Spree::Order do
  subject { Spree::Order.whitelisted_ransackable_attributes }

  it { is_expected.to include('exported_at') }
end
