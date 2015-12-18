class CreateWawas < ActiveRecord::Migration
  def change
    create_table :wawas do |t|
      t.decimal :lat, {:precision=>10, :scale=>6}
      t.decimal :long, {:precision=>10, :scale=>6}
      t.integer :user_id
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip
      t.string :info
      t.attachment :prime_photo

      t.timestamps null: false
    end
  end
end
