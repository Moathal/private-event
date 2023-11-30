# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_230_711_152_332) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'attendances', force: :cascade do |t|
    t.bigint 'attendee_id', null: false
    t.bigint 'host_id', null: false
    t.bigint 'event_id', null: false
    t.boolean 'invited_user'
    t.integer 'status'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['attendee_id'], name: 'index_attendances_on_attendee_id'
    t.index ['event_id'], name: 'index_attendances_on_event_id'
    t.index %w[host_id attendee_id], name: 'index_attendances_on_host_id_and_attendee_id', unique: true
    t.index ['host_id'], name: 'index_attendances_on_host_id'
  end

  create_table 'events', force: :cascade do |t|
    t.string 'location'
    t.date 'date'
    t.bigint 'creator_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.boolean 'public', default: true
    t.string 'name'
    t.index ['creator_id'], name: 'index_events_on_creator_id'
  end

  create_table 'notifications', force: :cascade do |t|
    t.string 'recipient_type', null: false
    t.bigint 'recipient_id', null: false
    t.string 'type', null: false
    t.jsonb 'params'
    t.datetime 'read_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['read_at'], name: 'index_notifications_on_read_at'
    t.index %w[recipient_type recipient_id], name: 'index_notifications_on_recipient'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'fullname'
    t.date 'birthday'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.boolean 'notify_invites', default: true
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'attendances', 'events'
  add_foreign_key 'attendances', 'users', column: 'attendee_id'
  add_foreign_key 'attendances', 'users', column: 'host_id'
  add_foreign_key 'events', 'users', column: 'creator_id'
end
