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

ActiveRecord::Schema.define(version: 20180118114207) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",                   default: 0
    t.string   "name"
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "constants", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extra_horarios", force: :cascade do |t|
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["student_id"], name: "index_extra_horarios_on_student_id", using: :btree
  end

  create_table "horarios", force: :cascade do |t|
    t.date     "from"
    t.date     "to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_id"
    t.index ["student_id"], name: "index_horarios_on_student_id", using: :btree
  end

  create_table "institute_users", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "contact_phone"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "institute_id"
    t.string   "email"
    t.string   "card_id"
    t.index ["institute_id"], name: "index_institute_users_on_institute_id", using: :btree
    t.index ["user_id"], name: "index_institute_users_on_user_id", using: :btree
  end

  create_table "institutes", force: :cascade do |t|
    t.string   "name"
    t.string   "calendar_schema"
    t.string   "address"
    t.string   "pbx"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: :cascade do |t|
    t.string   "bill_to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tutor_id"
    t.integer  "month"
    t.index ["tutor_id"], name: "index_invoices_on_tutor_id", using: :btree
  end

  create_table "line_items", force: :cascade do |t|
    t.decimal  "price"
    t.string   "description"
    t.integer  "quantity"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tutoria_id"
    t.index ["tutoria_id"], name: "index_line_items_on_tutoria_id", using: :btree
  end

  create_table "materia", force: :cascade do |t|
    t.string   "name"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "topic"
    t.integer  "order_id"
    t.decimal  "total_hours"
    t.decimal  "hourly_price"
    t.decimal  "sale_price"
    t.boolean  "weekly"
    t.integer  "materia_status_id"
    t.integer  "students_number"
    t.boolean  "active"
    t.boolean  "univ"
    t.date     "until_re_date"
    t.index ["materia_status_id"], name: "index_materia_on_materia_status_id", using: :btree
    t.index ["order_id"], name: "index_materia_on_order_id", using: :btree
    t.index ["student_id"], name: "index_materia_on_student_id", using: :btree
  end

  create_table "materia_instance_statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "materia_instances", force: :cascade do |t|
    t.decimal  "duration"
    t.date     "at_date"
    t.time     "at_time"
    t.integer  "materia_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tutor_id"
    t.integer  "materia_instance_status_id"
    t.integer  "parent_id"
    t.decimal  "tarifa"
    t.string   "tipo"
    t.integer  "order_id"
    t.index ["materia_id"], name: "index_materia_instances_on_materia_id", using: :btree
    t.index ["materia_instance_status_id"], name: "index_materia_instances_on_materia_instance_status_id", using: :btree
    t.index ["order_id"], name: "index_materia_instances_on_order_id", using: :btree
    t.index ["parent_id"], name: "index_materia_instances_on_parent_id", using: :btree
    t.index ["tutor_id"], name: "index_materia_instances_on_tutor_id", using: :btree
  end

  create_table "materia_statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "student_id"
    t.date     "re_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "for_month"
    t.text     "payment_ref"
    t.date     "payment_dateline"
    t.boolean  "init_cost"
    t.boolean  "renovate",            default: false
    t.integer  "serial"
    t.boolean  "active",              default: true
    t.integer  "admin_user_id"
    t.date     "payment_date"
    t.boolean  "curso"
    t.string   "created_by"
    t.decimal  "discount"
    t.decimal  "subtotal_sale_price"
    t.integer  "order_status_id"
    t.integer  "status"
    t.date     "re_dateline"
    t.string   "tarifa"
    t.boolean  "cerrado"
    t.integer  "students_number"
    t.integer  "hourly_payable"
    t.index ["admin_user_id"], name: "index_orders_on_admin_user_id", using: :btree
    t.index ["order_status_id"], name: "index_orders_on_order_status_id", using: :btree
    t.index ["student_id"], name: "index_orders_on_student_id", using: :btree
  end

  create_table "parents", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "payment"
    t.string   "address"
    t.string   "phone_alt1"
    t.string   "phone_alt2"
    t.string   "phone_main"
    t.string   "card_id_type"
    t.float    "subsidy_amount"
    t.string   "name_alt"
    t.string   "email_alt"
    t.string   "address_alt"
    t.text     "address_comment"
    t.integer  "user_id"
    t.index ["user_id"], name: "index_parents_on_user_id", using: :btree
  end

  create_table "students", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "school"
    t.string   "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "phone"
    t.string   "calendar_schema"
    t.integer  "parent_id"
    t.integer  "admin_user_id"
    t.boolean  "fixed"
    t.integer  "institute_id"
    t.index ["admin_user_id"], name: "index_students_on_admin_user_id", using: :btree
    t.index ["institute_id"], name: "index_students_on_institute_id", using: :btree
    t.index ["parent_id"], name: "index_students_on_parent_id", using: :btree
  end

  create_table "tareas", force: :cascade do |t|
    t.integer  "admin_user_id"
    t.string   "title"
    t.boolean  "is_done"
    t.date     "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",        default: "Pendiente"
    t.index ["admin_user_id"], name: "index_tareas_on_admin_user_id", using: :btree
  end

  create_table "tutor_slots", force: :cascade do |t|
    t.string   "day"
    t.time     "from_hour"
    t.time     "to_hour"
    t.integer  "tutor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["tutor_id"], name: "index_tutor_slots_on_tutor_id", using: :btree
  end

  create_table "tutoria", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "recurrence"
    t.string   "status"
    t.integer  "tutor_id"
    t.float    "duration"
    t.string   "topic"
    t.integer  "students_number"
    t.integer  "sessions"
    t.float    "hours"
    t.string   "schedule"
    t.date     "first"
    t.index ["order_id"], name: "index_tutoria_on_order_id", using: :btree
    t.index ["tutor_id"], name: "index_tutoria_on_tutor_id", using: :btree
  end

  create_table "tutoria_instances", force: :cascade do |t|
    t.text     "topic"
    t.integer  "tutor_id"
    t.integer  "tutoria_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "duration"
    t.integer  "order_id"
    t.string   "status",           default: "avaible"
    t.integer  "student_id"
    t.string   "subject"
    t.integer  "serial"
    t.integer  "student_number"
    t.date     "at_date"
    t.time     "at_time"
    t.string   "recurrence",       default: "fija"
    t.boolean  "copy",             default: true
    t.integer  "extra_horario_id"
    t.integer  "materia_id"
    t.index ["extra_horario_id"], name: "index_tutoria_instances_on_extra_horario_id", using: :btree
    t.index ["materia_id"], name: "index_tutoria_instances_on_materia_id", using: :btree
    t.index ["order_id"], name: "index_tutoria_instances_on_order_id", using: :btree
    t.index ["student_id"], name: "index_tutoria_instances_on_student_id", using: :btree
    t.index ["tutor_id"], name: "index_tutoria_instances_on_tutor_id", using: :btree
    t.index ["tutoria_id"], name: "index_tutoria_instances_on_tutoria_id", using: :btree
  end

  create_table "tutors", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                  default: "",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.text     "profile",                default: [],                array: true
    t.integer  "category"
    t.string   "level"
    t.string   "university"
    t.string   "grade"
    t.string   "homephone"
    t.string   "cellphone"
    t.string   "major"
    t.boolean  "status",                 default: true
    t.string   "card_id",                default: ""
    t.text     "specific_experience"
    t.text     "school_experience"
    t.text     "language_experience",    default: [],                array: true
    t.integer  "user_id"
    t.boolean  "non_fixed"
    t.index ["email"], name: "index_tutors_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_tutors_on_reset_password_token", unique: true, using: :btree
    t.index ["user_id"], name: "index_tutors_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "role"
    t.integer  "user_role_id"
    t.string   "user_role_type"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "materia_instances", "orders"
  add_foreign_key "materia_instances", "parents"
end
