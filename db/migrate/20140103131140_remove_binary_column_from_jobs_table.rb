class RemoveBinaryColumnFromJobsTable < ActiveRecord::Migration
  def change
  	remove_column :jobs, :binary_data
  end
end
