class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.integer :wawa_id
      t.integer :user_id
      t.attachment :image

      t.timestamps null: false
    end
  end
end
