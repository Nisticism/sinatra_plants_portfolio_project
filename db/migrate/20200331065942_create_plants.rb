class CreatePlants < ActiveRecord::Migration[5.1]
  def change
    create_table :plants do |t|
      t.string :species
      t.string :sprout_date
      t.float :price
      t.integer :quantity
      t.integer :user_id
    end
  end
end
