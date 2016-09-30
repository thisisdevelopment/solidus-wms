module Wms
  class AttachmentMailer
    def deliver(attachment_path)
      Spree::WmsConfig.order_xls_export_mailer_class.latest(attachment_path).deliver_now
    end
  end
end
