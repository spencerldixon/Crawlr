class AddBinaryDataToJobsTable < ActiveRecord::Migration
  def change
  	add_column :jobs, :binary_data, :binary
  end
end
