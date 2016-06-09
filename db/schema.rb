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

ActiveRecord::Schema.define(version: 20160605235000) do

  create_table "admi_mas", force: :cascade do |t|
    t.string   "name"
    t.decimal  "examMark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admi_mbs", force: :cascade do |t|
    t.string   "name"
    t.decimal  "examMark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admi_vas", force: :cascade do |t|
    t.string   "name"
    t.decimal  "examMark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conta_mas", force: :cascade do |t|
    t.string   "name"
    t.decimal  "examMark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conta_vas", force: :cascade do |t|
    t.string   "name"
    t.decimal  "examMark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "electro_mas", force: :cascade do |t|
    t.string   "name"
    t.decimal  "examMark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "electro_vas", force: :cascade do |t|
    t.string   "name"
    t.decimal  "examMark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.decimal  "examMark"
    t.decimal  "schoolAverage"
    t.boolean  "isRecommended"
    t.boolean  "isForeign"
    t.string   "speciality"
    t.string   "secondSpeciality"
    t.string   "finalSpeciality"
    t.string   "group"
    t.string   "turn"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "meca_vas", force: :cascade do |t|
    t.string   "name"
    t.decimal  "examMark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "progra_mas", force: :cascade do |t|
    t.string   "name"
    t.decimal  "examMark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "progra_mbs", force: :cascade do |t|
    t.string   "name"
    t.decimal  "examMark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "progra_vas", force: :cascade do |t|
    t.string   "name"
    t.decimal  "examMark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "progra_vbs", force: :cascade do |t|
    t.string   "name"
    t.decimal  "examMark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requests", force: :cascade do |t|
    t.string   "name"
    t.decimal  "examMark"
    t.decimal  "schoolAverage"
    t.boolean  "isRecommended"
    t.boolean  "isForeign"
    t.integer  "speciality"
    t.integer  "secondSpeciality"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

end
