class CreateAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :attendances do |t|
      t.string :location
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.references :invited_user, foreign_key: { to_table: :users }
      t.references :attendances, :status, :integer

      t.timestamps
    end

    add_index :attendances, [:event_id, :user_id], unique: true
  end
end
