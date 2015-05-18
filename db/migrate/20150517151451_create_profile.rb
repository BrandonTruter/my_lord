class CreateProfile < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :middle_name
      t.boolean :married, :default => false
      t.string :language
      t.string :race
      t.string :religion
      t.string :phone
      t.string :fax
      t.string :qualifications
      t.string :hobbies
      t.string :interests
      t.string :company
      t.string :position
      t.string :occupation
      t.string :gender
      t.datetime :date_of_birth
      t.integer :family_size
      t.float :net_salary
      t.string :street_number
      t.string :street_name
      t.string :suburb
      t.string :city
      t.string :province
      t.string :postal_code
      t.string :spouse_first_name
      t.string :spouse_last_name
      t.string :spouse_occupation

      t.timestamps
    end
  end
end
