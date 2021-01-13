module SolidusWms
  module AdditionalAdminReports
    extend ActiveSupport::Concern

    def initialize
      super
      ::Spree::Admin::ReportsController.add_available_report!(:unexported_orders)
    end

    def unexported_orders
      params[:q] = {} unless params[:q]

      parsed_completed_at_time_param

      params[:q][:store_id_eq] = current_store.id unless params[:q][:store_id_eq].present?

      params[:q][:s] = 'completed_at desc' unless params[:q][:s].present?

      @search = Spree::Order.complete.not_exported.ransack(params[:q])
      @orders = orders_with_relations.page(params[:page]).per(Spree::Config[:orders_per_page])
      @total_orders = @orders.count
    end

    private

    def orders_with_relations
      if current_store.use_stock
        @search.result.includes(:line_items, :variants)
      else
        @search.result
      end
    end

    def parsed_completed_at_time_param
      params[:q][:completed_at_gt] =
        begin
          Time.zone.parse(params[:q][:completed_at_gt]).beginning_of_day
        rescue
          Time.zone.now.beginning_of_month
        end
    end
  end
end
