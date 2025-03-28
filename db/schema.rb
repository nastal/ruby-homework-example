# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_02_06_093627) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.string "coat_of_arms_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_cities_on_name", unique: true
  end

  create_table "hotels", force: :cascade do |t|
    t.text "display_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "city_id", null: false
    t.integer "place_id", null: false
    t.index ["city_id", "place_id"], name: "index_hotels_on_city_id_and_place_id", unique: true
    t.index ["city_id"], name: "index_hotels_on_city_id"
    t.index ["display_name"], name: "index_hotels_on_display_name"
    t.index ["place_id"], name: "index_hotels_on_place_id", unique: true
  end

  add_foreign_key "hotels", "cities"
end
