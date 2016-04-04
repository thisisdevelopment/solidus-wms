module SolidusWms
  module OrderExportedAt
    extend ActiveSupport::Concern

    def export
      touch(:exported_at)
    end

    def exported?
      exported_at.present?
    end
  end
end
