class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true
  # before_destroy :prevent_deletion

  # private

  # def prevent_deletion
  #   puts "<><><><><><><><><><><><><><><><><> PREVENT DELETION CALL <><><><><><><><><><><><><><><>"
  #   throw(:abort)
  # end
end
