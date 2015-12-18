class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :username
      t.string :fname
      t.string :lname
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :level
      t.integer :submitted
      t.attachment :avatar

      t.timestamps null: false
    end
  end
end
