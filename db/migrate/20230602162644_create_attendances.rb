# frozen_string_literal: true

class CreateAttendances < ActiveRecord::Migration[6.0]
  def change
    create_table :attendances do |t|
      t.references :attendee, null: false, foreign_key: { to_table: :users }
      t.references :host, null: false, foreign_key: { to_table: :users }
      t.references :event, null: false, foreign_key: true
      t.boolean :invited_user
      t.integer :status
      t.timestamps
    end
    add_index :attendances, %i[host_id attendee_id], unique: true
  end
end
