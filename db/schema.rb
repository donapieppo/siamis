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
    t.index ["presentation_id"], name: "presentation_id", using: :btree
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "organizers", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id",    null: false, unsigned: true
    t.integer "session_id",              unsigned: true
    t.index ["session_id"], name: "session_id", using: :btree
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "payments", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",                 unsigned: true
    t.string   "shopid"
    t.string   "paymentid",    limit: 40
    t.string   "shopuserref"
    t.string   "shopusername"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "presentations", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name"
    t.text    "abstract",   limit: 65535
    t.integer "session_id",               unsigned: true
    t.index ["session_id"], name: "session_id", using: :btree
  end

  create_table "ratings", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id",                  null: false, unsigned: true
    t.integer "session_id",                            unsigned: true
    t.integer "score"
    t.text    "notes",      limit: 65535
    t.index ["session_id"], name: "session_id", using: :btree
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "rooms", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name"
    t.string  "address"
    t.integer "capacity"
  end

  create_table "sessions", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "type",        limit: 40
    t.string  "name"
    t.text    "description", limit: 65535
    t.boolean "accepted"
  end

  create_table "users", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.string   "affiliation"
    t.text     "address",     limit: 65535
    t.datetime "updated_at"
  end

end
