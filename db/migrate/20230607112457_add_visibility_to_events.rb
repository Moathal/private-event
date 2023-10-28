class AddVisibilityToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :public, :boolean, default: true
  end
end
