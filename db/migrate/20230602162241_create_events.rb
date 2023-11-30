# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :location
      t.date :date
      t.references :creator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
