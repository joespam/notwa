class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :password
      t.boolean :admin
      t.integer :profile_id

      t.timestamps null: false
    end
  end
end
