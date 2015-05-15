class CreateScriptures < ActiveRecord::Migration
  def change
    create_table :scriptures do |t|      
      t.string :title
      t.string :reference
      t.string :verse
      t.references :user
      
      t.timestamps null: false
    end
  end
end