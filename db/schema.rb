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

ActiveRecord::Schema.define(version: 20140515071131) do

  create_table "bill_actors", id: false, force: true do |t|
    t.integer  "bill_id"
    t.integer  "user_id"
    t.integer  "due",        limit: 8
    t.date     "paid_date"
    t.boolean  "paid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bills", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "title"
    t.string   "description"
    t.date     "due_date"
    t.integer  "total_due",   limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "creator"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "self"
  end

  create_table "memberships", id: false, force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id"
  add_index "memberships", ["user_id", "group_id"], name: "index_memberships_on_user_id_and_group_id", unique: true
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id"

  create_table "task_actors", id: false, force: true do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_generator_actors", id: false, force: true do |t|
    t.integer  "task_generator_id"
    t.integer  "user_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_generators", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "title"
    t.string   "description"
    t.date     "finished_date"
    t.boolean  "finished"
    t.text     "repeat_days"
    t.boolean  "cycle"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_task_id"
  end

  create_table "tasks", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "title"
    t.string   "description"
    t.date     "due_date"
    t.date     "finished_date"
    t.boolean  "finished"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
