class AddUserIdtoJob < ActiveRecord::Migration
  def change
  	add_column :jobs, :user_id, :integer
  	add_index :jobs, :user_id
  end
end
