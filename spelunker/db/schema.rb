# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141217182441) do

  create_table "artist_things", force: true do |t|
    t.integer  "artist_id"
    t.integer  "thing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artist_things", ["artist_id"], name: "index_artist_things_on_artist_id", using: :btree
  add_index "artist_things", ["thing_id"], name: "index_artist_things_on_thing_id", using: :btree

  create_table "artists", force: true do |t|
    t.string   "name",       limit: 500
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "material_technique_things", force: true do |t|
    t.integer  "material_technique_id"
    t.integer  "thing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "material_technique_things", ["material_technique_id"], name: "index_material_technique_things_on_material_technique_id", using: :btree
  add_index "material_technique_things", ["thing_id"], name: "index_material_technique_things_on_thing_id", using: :btree

  create_table "material_techniques", force: true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "material_things", force: true do |t|
    t.integer  "material_id"
    t.integer  "thing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "material_things", ["material_id"], name: "index_material_things_on_material_id", using: :btree
  add_index "material_things", ["thing_id"], name: "index_material_things_on_thing_id", using: :btree

  create_table "materials", force: true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "place_things", force: true do |t|
    t.integer  "place_id"
    t.integer  "thing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "place_things", ["place_id"], name: "index_place_things_on_place_id", using: :btree
  add_index "place_things", ["thing_id"], name: "index_place_things_on_thing_id", using: :btree

  create_table "places", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "technique_things", force: true do |t|
    t.integer  "technique_id"
    t.integer  "thing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "technique_things", ["technique_id"], name: "index_technique_things_on_technique_id", using: :btree
  add_index "technique_things", ["thing_id"], name: "index_technique_things_on_thing_id", using: :btree

  create_table "techniques", force: true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "va_collection_museumobject", force: true do |t|
    t.string   "object",                    limit: 100,                                 null: false
    t.text     "title",                     limit: 2147483647,                          null: false
    t.string   "slug"
    t.string   "collection_code",           limit: 10,                                  null: false
    t.string   "artist",                    limit: 500,                                 null: false
    t.string   "place",                     limit: 500,                                 null: false
    t.decimal  "latitude",                                     precision: 10, scale: 8
    t.decimal  "longitude",                                    precision: 11, scale: 8
    t.string   "location",                                                              null: false
    t.text     "materials_techniques",      limit: 2147483647,                          null: false
    t.text     "dimensions",                limit: 2147483647,                          null: false
    t.text     "museum_number",             limit: 2147483647,                          null: false
    t.string   "object_number",             limit: 10,                                  null: false
    t.string   "edition_number",            limit: 50,                                  null: false
    t.text     "descriptive_line",          limit: 2147483647,                          null: false
    t.text     "physical_description",      limit: 2147483647,                          null: false
    t.text     "public_access_description", limit: 2147483647,                          null: false
    t.string   "shape",                                                                 null: false
    t.string   "credit",                    limit: 600,                                 null: false
    t.text     "historical_context_note",   limit: 2147483647,                          null: false
    t.text     "historical_significance",   limit: 2147483647,                          null: false
    t.text     "history_note",              limit: 2147483647,                          null: false
    t.text     "attributions_note",         limit: 2147483647,                          null: false
    t.string   "production_type",                                                       null: false
    t.text     "production_note",           limit: 2147483647,                          null: false
    t.text     "marks",                     limit: 2147483647,                          null: false
    t.text     "label",                     limit: 2147483647,                          null: false
    t.text     "bibliography",              limit: 2147483647,                          null: false
    t.text     "event_text",                limit: 2147483647,                          null: false
    t.text     "vanda_exhibition_history",  limit: 2147483647,                          null: false
    t.text     "exhibition_history",        limit: 2147483647,                          null: false
    t.text     "related_museum_numbers",    limit: 2147483647,                          null: false
    t.string   "primary_image_id",          limit: 50,                                  null: false
    t.text     "date_text",                 limit: 2147483647,                          null: false
    t.date     "date_start"
    t.date     "date_end"
    t.integer  "year_start"
    t.integer  "year_end"
    t.string   "original_price",            limit: 32,                                  null: false
    t.string   "original_currency",         limit: 64,                                  null: false
    t.datetime "updated"
    t.integer  "rights",                                                                null: false
    t.datetime "last_checked"
    t.datetime "sys_updated"
    t.datetime "last_processed"
    t.string   "museum_number_token"
    t.text     "techniques",                limit: 2147483647
    t.text     "materials",                 limit: 2147483647
    t.boolean  "on_display"
    t.string   "site_code",                 limit: 10
    t.string   "gallery"
  end

  add_index "va_collection_museumobject", ["collection_code"], name: "va_collection_museumobject_c3634130", using: :btree
  add_index "va_collection_museumobject", ["date_end"], name: "va_collection_museumobject_6d5a0d1", using: :btree
  add_index "va_collection_museumobject", ["date_start"], name: "va_collection_museumobject_2bd90934", using: :btree
  add_index "va_collection_museumobject", ["latitude"], name: "va_collection_museumobject_9c76b1bb", using: :btree
  add_index "va_collection_museumobject", ["location"], name: "location", using: :btree
  add_index "va_collection_museumobject", ["longitude"], name: "va_collection_museumobject_761a2bbd", using: :btree
  add_index "va_collection_museumobject", ["museum_number_token"], name: "va_collection_museumobject_ea13d9b2", using: :btree
  add_index "va_collection_museumobject", ["object"], name: "va_collection_museumobject_598d90d4", using: :btree
  add_index "va_collection_museumobject", ["object_number"], name: "object_number", unique: true, using: :btree
  add_index "va_collection_museumobject", ["place"], name: "place", length: {"place"=>255}, using: :btree
  add_index "va_collection_museumobject", ["primary_image_id"], name: "va_collection_museumobject_9456f803", using: :btree
  add_index "va_collection_museumobject", ["rights"], name: "va_collection_museumobject_1cf7f7e8", using: :btree
  add_index "va_collection_museumobject", ["slug"], name: "va_collection_museumobject_a951d5d6", using: :btree
  add_index "va_collection_museumobject", ["updated"], name: "va_collection_museumobject_8aac229", using: :btree
  add_index "va_collection_museumobject", ["year_end"], name: "va_collection_museumobject_63fb9106", using: :btree
  add_index "va_collection_museumobject", ["year_start"], name: "va_collection_museumobject_ea9a6191", using: :btree

end
