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

  create_table "admins", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id", null: false, unsigned: true
    t.integer "wall_id", null: false, unsigned: true
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "minisymposia", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name"
    t.text    "description", limit: 65535
    t.boolean "accepted"
  end

  create_table "minisymposia_proposal_users", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "minisymposium_id", null: false, unsigned: true
    t.integer "proposal_user_id", null: false, unsigned: true
    t.index ["minisymposium_id"], name: "minisymposium_id", using: :btree
    t.index ["proposal_user_id"], name: "proposal_user_id", using: :btree
  end

  create_table "minisymposia_users", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "minisymposium_id", null: false, unsigned: true
    t.integer "user_id",          null: false, unsigned: true
    t.index ["minisymposium_id"], name: "minisymposium_id", using: :btree
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "minitutorials", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name"
    t.text    "description", limit: 65535
    t.boolean "accepted"
  end

  create_table "organizers", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id",          null: false, unsigned: true
    t.boolean "commette"
    t.integer "minisymposium_id", null: false, unsigned: true
    t.integer "minitutorial_id",  null: false, unsigned: true
    t.index ["minisymposium_id"], name: "minisymposium_id", using: :btree
    t.index ["minitutorial_id"], name: "minitutorial_id", using: :btree
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "presentations", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "type"
    t.string "name"
    t.text   "abstract", limit: 65535
  end

  create_table "proposal_users", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "surname"
    t.string "email"
    t.string "affiliation"
    t.text   "address",     limit: 65535
  end

  create_table "sessions", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text   "description", limit: 65535
  end

  create_table "speakers", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id",                       null: false, unsigned: true
    t.integer "presentation_id",               null: false, unsigned: true
    t.text    "description",     limit: 65535
    t.index ["presentation_id"], name: "presentation_id", using: :btree
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "users", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.string   "affiliation"
    t.text     "address",     limit: 65535
    t.datetime "updated_at"
  end

  add_foreign_key "admins", "users", name: "admins_ibfk_1"
  add_foreign_key "minisymposia_proposal_users", "minisymposia", name: "minisymposia_proposal_users_ibfk_1"
  add_foreign_key "minisymposia_proposal_users", "proposal_users", name: "minisymposia_proposal_users_ibfk_2"
  add_foreign_key "minisymposia_users", "minisymposia", name: "minisymposia_users_ibfk_1"
  add_foreign_key "minisymposia_users", "users", name: "minisymposia_users_ibfk_2"
  add_foreign_key "organizers", "users", name: "organizers_ibfk_1"
  add_foreign_key "speakers", "presentations", name: "speakers_ibfk_2"
  add_foreign_key "speakers", "users", name: "speakers_ibfk_1"
end
