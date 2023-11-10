# frozen_string_literal: true

class AddNotifyInvitesToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :notify_invites, :boolean, default: true
  end
end
