class AddReceivedAtToSpreeShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :received_at, :datetime, default: nil
  end
end
