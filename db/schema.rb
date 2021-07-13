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

ActiveRecord::Schema.define(version: 2021_07_13_072907) do

  create_table "comments", force: :cascade do |t|
    t.integer "expense_id", null: false
    t.text "description"
    t.text "reply"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["expense_id"], name: "index_comments_on_expense_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "department"
    t.string "gender"
    t.string "contact"
    t.boolean "admin", default: false
    t.boolean "active_status", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "expense_groups", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.string "title"
    t.integer "applied_amount", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", default: "null"
    t.integer "approved_amount", default: 0
    t.index ["employee_id"], name: "index_expense_groups_on_employee_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.integer "expense_group_id", null: false
    t.integer "invoice_number"
    t.date "date"
    t.text "description"
    t.integer "amount"
    t.string "attachment"
    t.boolean "expense_system_validate", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", default: "null"
    t.index ["expense_group_id"], name: "index_expenses_on_expense_group_id"
  end

  add_foreign_key "comments", "expenses"
  add_foreign_key "expense_groups", "employees"
  add_foreign_key "expenses", "expense_groups"
end
