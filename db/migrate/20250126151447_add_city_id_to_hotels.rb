class AddCityIdToHotels < ActiveRecord::Migration[7.1]
  def change
    add_reference :hotels, :city, null: false, foreign_key: true
    remove_column :hotels, :city, :string

    add_index :hotels, [:city_id, :display_name], unique: true
    add_index :hotels, :display_name
  end
end
