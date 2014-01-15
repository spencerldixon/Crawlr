class AddStatusToSitesModel < ActiveRecord::Migration
  def change
  	add_column :sites, :status, :string, default: "pending"
  end
end
