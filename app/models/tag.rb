class Tag < ApplicationRecord
  has_and_belongs_to_many :notes, -> { distinct }

  validates :name, presence: true, uniqueness: true

  # def user_notes(user)
  #   user.created_notes.where
  # end
end
