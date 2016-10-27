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

ActiveRecord::Schema.define(version: 0) do

  create_table "authors", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id",         null: false, unsigned: true
    t.integer "presentation_id",              unsigned: true
    t.boolean "speak"
    t.index ["presentation_id"], name: "presentation_id", using: :btree
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "buildings", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "address"
    t.string "city"
  end

  create_table "organizers", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id",    null: false, unsigned: true
    t.integer "session_id",              unsigned: true
    t.index ["session_id"], name: "session_id", using: :btree
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "payments", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",                 unsigned: true
    t.string   "seed",         limit: 32
    t.string   "shop_id"
    t.string   "payment_id",   limit: 40
    t.string   "shopuserref"
    t.string   "shopusername"
    t.integer  "amount"
    t.boolean  "verified"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "presentations", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name"
    t.text    "abstract",   limit: 65535
    t.integer "session_id",               unsigned: true
    t.boolean "accepted"
    t.boolean "poster"
    t.index ["session_id"], name: "session_id", using: :btree
  end

  create_table "ratings", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id",                       null: false, unsigned: true
    t.integer "session_id",                                 unsigned: true
    t.integer "presentation_id",                            unsigned: true
    t.integer "score"
    t.text    "notes",           limit: 65535
    t.index ["session_id"], name: "session_id", using: :btree
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "registrations", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",    unsigned: true
    t.integer  "payment_id", unsigned: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "rooms", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name"
    t.integer "capacity"
    t.integer "building_id", unsigned: true
    t.index ["building_id"], name: "building_id", using: :btree
  end

  create_table "schedules", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "session_id", unsigned: true
    t.integer  "room_id",    unsigned: true
    t.datetime "start"
    t.index ["room_id"], name: "room_id", using: :btree
    t.index ["session_id"], name: "session_id", using: :btree
  end

  create_table "sessions", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "type",        limit: 18
    t.integer  "number"
    t.string   "name"
    t.text     "description", limit: 65535
    t.boolean  "accepted"
    t.integer  "room_id",                   unsigned: true
    t.integer  "chair_id",                  unsigned: true
    t.datetime "start"
    t.index ["chair_id"], name: "chair_id", using: :btree
    t.index ["room_id"], name: "room_id", using: :btree
  end

  create_table "users", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.string   "affiliation"
    t.text     "address",     limit: 65535
    t.string   "country"
    t.text     "biography",   limit: 65535
    t.boolean  "siag"
    t.boolean  "siam"
    t.boolean  "student"
    t.datetime "updated_at"
  end

end
