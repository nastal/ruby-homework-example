class CreateHotels < ActiveRecord::Migration[7.0]
  def change
    create_table :hotels do |t|
      t.string :city
      t.text :display_name

      t.timestamps
    end
  end
end
