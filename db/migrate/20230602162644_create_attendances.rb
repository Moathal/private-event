class CreateAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :attendances do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.boolean :invited_user
      t.integer :status

      t.timestamps
    end

    add_index :attendances, [:event_id, :user_id], unique: true
  end
end
