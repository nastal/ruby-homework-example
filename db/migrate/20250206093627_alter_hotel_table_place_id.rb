class AlterHotelTablePlaceId < ActiveRecord::Migration[7.1]
  def change
    remove_index :hotels, %i[city_id display_name], unique: true

    add_column :hotels, :place_id, :integer, null: false

    add_index :hotels, %i[city_id place_id], unique: true
    add_index :hotels, :place_id, unique: true

  end
end
