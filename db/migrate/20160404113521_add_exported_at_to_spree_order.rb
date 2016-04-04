class AddExportedAtToSpreeOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :exported_at, :datetime
  end
end
