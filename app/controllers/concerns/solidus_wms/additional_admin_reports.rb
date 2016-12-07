module SolidusWms
  module AdditionalAdminReports
    extend ActiveSupport::Concern

    def initialize
      super
      ::Spree::Admin::ReportsController.add_available_report!(:unexported_orders)
    end

    def unexported_orders
      params[:q] = {} unless params[:q]

      if params[:q][:completed_at_gt].blank?
        params[:q][:completed_at_gt] = Time.zone.now.beginning_of_month
      else
        params[:q][:completed_at_gt] = parsed_completed_at_time
      end

      params[:q][:store_id_eq] = current_store.id unless params[:q][:store_id_eq].present?

      params[:q][:s] = 'completed_at desc'

      @search = Spree::Order.complete.not_exported.ransack(params[:q])
      @orders = @search.result
    end

    private

    def parsed_completed_at_time
      Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day
    rescue
      Time.zone.now.beginning_of_month
    end
  end
end
