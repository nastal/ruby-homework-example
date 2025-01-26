class CreateCities < ActiveRecord::Migration[7.1]
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.string :coat_of_arms_url

      t.timestamps
    end

    add_index :cities, :name, unique: true
  end
end
