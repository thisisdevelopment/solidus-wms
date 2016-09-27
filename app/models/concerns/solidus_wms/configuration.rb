module SolidusWms
  class Configuration < ::Spree::Preferences::Configuration
    attr_accessor :order_xls_export_class
  end
end
