module Wms
  class AttachmentMailer
    def initialize(recipients: nil)
      @recipients = recipients
    end

    def deliver(attachment_path)
      Spree::WmsConfig.order_xls_export_mailer_class.latest(attachment_path, @recipients).deliver_now
    end
  end
end
