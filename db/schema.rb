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

ActiveRecord::Schema.define(version: 20150217170506) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrations", force: true do |t|
    t.integer  "admin_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "post_id"
    t.text     "content"
    t.string   "session_id"
    t.string   "author_name"
    t.integer  "flagged",     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",      default: 0
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree

  create_table "flaggings", force: true do |t|
    t.string   "session_id"
    t.string   "flaggable_type"
    t.integer  "flaggable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flaggings", ["flaggable_id", "flaggable_type"], name: "index_flaggings_on_flaggable_id_and_flaggable_type", using: :btree
  add_index "flaggings", ["session_id"], name: "index_flaggings_on_session_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "description"
  end

  add_index "locations", ["slug"], name: "index_locations_on_slug", using: :btree

  create_table "posts", force: true do |t|
    t.text     "content"
    t.string   "session_id"
    t.string   "gender"
    t.string   "hair"
    t.string   "spotted_at"
    t.integer  "flagged",     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.integer  "status",      default: 0
  end

end
