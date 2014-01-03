class AddDefaultValueToStatusFieldOnJobsTable < ActiveRecord::Migration
  def change
  	change_column :jobs, :status, :string, default: "pending"
  end
end
