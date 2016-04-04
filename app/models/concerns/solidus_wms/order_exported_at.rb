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
    end

    def export!
      raise ActiveRecord::ActiveRecordError unless complete?

      touch(:exported_at)
    end

    def exported?
      exported_at.present?
    end
  end
end
