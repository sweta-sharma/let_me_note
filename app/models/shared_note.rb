class SharedNote < ApplicationRecord
  validates_presence_of :permission, :user_id, :note_id
  validates :permission, inclusion: {
                         in: %w(read write owner),
                         message: "%{value} is not a valid permission"
                       }

  enum permission: [:read, :write, :owner]
end
