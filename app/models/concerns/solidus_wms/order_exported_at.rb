module SolidusWms
  module OrderExportedAt
    extend ActiveSupport::Concern

    included do
      def self.exported
        where.not(exported_at: nil)
      end

      def self.not_exported
        where(exported_at: nil)
      end

      def self.to_export(timestamp)
        not_exported.where(shipment_state: 'ready').where("completed_at <= ?", timestamp)
      end
    end

    def export!
      raise StandardError unless complete?

      touch(:exported_at)
    end

    def exported?
      exported_at.present?
    end
  end
end
