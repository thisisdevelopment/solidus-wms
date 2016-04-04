module SolidusWms
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'solidus_wms'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      Spree::Order.include(SolidusWms::OrderExportedAt)

      Spree::Order.whitelisted_ransackable_attributes << 'exported_at'

      Spree::Shipment.whitelisted_ransackable_attributes << 'state'
      Spree::Shipment.whitelisted_ransackable_attributes << 'created_at'
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
