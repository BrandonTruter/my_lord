class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :roles, :string, :default => "--- ['user']"
    add_column :users, :monthly_scripture, :boolean
    add_column :users, :completed_registration, :boolean, :default => false
    
    add_attachment :users, :avatar
    
    remove_column :users, :married
    remove_column :users, :language
    remove_column :users, :race
    remove_column :users, :phone
    remove_column :users, :fax
    remove_column :users, :position
    remove_column :users, :employer
  end  
end
