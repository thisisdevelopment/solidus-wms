module Wms
  class AttachmentMailer
    def present(filepath)
      Spree::WmsConfig.order_xls_export_mailer_class.latest(filepath).deliver_now
    end
  end
end
