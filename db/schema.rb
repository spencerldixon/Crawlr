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

ActiveRecord::Schema.define(version: 20140115155728) do

  create_table "jobs", force: true do |t|
    t.string   "url"
    t.string   "keyword"
    t.string   "status",     default: "pending"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "jobs", ["user_id"], name: "index_jobs_on_user_id"

  create_table "news", force: true do |t|
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.integer  "site_id"
    t.boolean  "passed"
    t.string   "error_message"
    t.boolean  "basic_test"
    t.boolean  "head_banner"
    t.boolean  "head_mediabar"
    t.boolean  "body_banner"
    t.boolean  "body_mediabar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uri"
  end

  create_table "sites", force: true do |t|
    t.string   "url"
    t.string   "urn"
    t.integer  "user_id"
    t.float    "crawl_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",     default: "pending"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
