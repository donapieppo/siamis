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

  create_table "buildings", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "description"
    t.string "address"
    t.string "city"
    t.float "lat", limit: 24
    t.float "lng", limit: 24
  end

  create_table "conference_registrations", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id", unsigned: true
    t.integer "payment_id", unsigned: true
    t.date "single_day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "user_id"
  end

  create_table "conference_sessions", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "type", limit: 18
    t.integer "number"
    t.string "name"
    t.text "description"
    t.boolean "accepted"
    t.integer "chair_id", unsigned: true
    t.datetime "start"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["chair_id"], name: "chair_id"
  end

  create_table "hotels", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "description"
    t.string "address"
    t.integer "singleprice"
    t.integer "singleprice_deluxe"
    t.integer "dusprice"
    t.integer "dusprice_deluxe"
    t.integer "doubleprice"
    t.integer "doubleprice_deluxe"
    t.integer "suiteprice"
    t.integer "juniorsuiteprice"
    t.integer "apartment"
    t.boolean "bb"
    t.boolean "tax"
    t.string "web_page"
    t.string "image"
    t.float "lat", limit: 24
    t.float "lng", limit: 24
  end

  create_table "interests", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id", unsigned: true
    t.integer "conference_session_id", unsigned: true
    t.integer "presentation_id", unsigned: true
    t.index ["conference_session_id"], name: "conference_session_id"
    t.index ["presentation_id"], name: "presentation_id"
    t.index ["user_id"], name: "user_id"
  end

  create_table "invitation_letters", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id", unsigned: true
    t.string "passport_name"
    t.string "birthdate"
    t.string "passport_origin"
    t.string "passport_number"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "user_id"
  end

  create_table "papers", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "presentation_id", unsigned: true
    t.text "paperfile_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["presentation_id"], name: "presentation_id"
  end

  create_table "parts", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "num", null: false, unsigned: true
    t.integer "conference_session_id", unsigned: true
    t.index ["conference_session_id"], name: "conference_session_id"
  end

  create_table "payments", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id", unsigned: true
    t.string "seed", limit: 32
    t.string "shop_id"
    t.string "payment_id", limit: 40
    t.string "shopuserref"
    t.string "shopusername"
    t.integer "amount"
    t.boolean "siag"
    t.boolean "siam"
    t.boolean "student"
    t.date "single_day"
    t.boolean "verified"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "user_id"
  end

  create_table "presentations", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "abstract"
    t.integer "conference_session_id", unsigned: true
    t.integer "number"
    t.boolean "poster"
    t.boolean "accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["conference_session_id"], name: "conference_session_id"
  end

  create_table "ratings", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id", null: false, unsigned: true
    t.integer "conference_session_id", unsigned: true
    t.integer "presentation_id", unsigned: true
    t.integer "score"
    t.text "notes"
    t.index ["conference_session_id"], name: "conference_session_id"
    t.index ["user_id"], name: "user_id"
  end

  create_table "roles", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "type", limit: 9
    t.integer "user_id", null: false, unsigned: true
    t.integer "conference_session_id", unsigned: true
    t.integer "presentation_id", unsigned: true
    t.boolean "speak"
    t.index ["conference_session_id"], name: "conference_session_id"
    t.index ["presentation_id"], name: "presentation_id"
    t.index ["user_id"], name: "user_id"
  end

  create_table "rooms", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "capacity"
    t.integer "building_id", unsigned: true
    t.integer "floor"
    t.index ["building_id"], name: "building_id"
  end

  create_table "schedules", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "conference_session_id", unsigned: true
    t.integer "room_id", unsigned: true
    t.datetime "start"
    t.index ["conference_session_id"], name: "conference_session_id"
    t.index ["room_id"], name: "room_id"
  end

  create_table "taggins", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "tag_id", null: false, unsigned: true
    t.integer "presentation_id", unsigned: true
    t.integer "conference_session_id", unsigned: true
    t.index ["conference_session_id"], name: "conference_session_id"
    t.index ["presentation_id"], name: "presentation_id"
    t.index ["tag_id"], name: "tag_id"
  end

  create_table "tags", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.boolean "global"
    t.index ["name"], name: "name"
  end

  create_table "users", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "salutation", limit: 20
    t.string "name"
    t.string "surname"
    t.string "email"
    t.string "affiliation"
    t.string "address"
    t.string "country"
    t.text "biography"
    t.boolean "siag"
    t.boolean "siam"
    t.boolean "student"
    t.string "web_page"
    t.text "dietary"
    t.integer "banquet_tickets"
    t.boolean "visible"
    t.string "encrypted_password"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "notified_at"
    t.datetime "updated_at"
    t.index ["email"], name: "email"
  end

end
