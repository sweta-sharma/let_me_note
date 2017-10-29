class Note < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  has_and_belongs_to_many :tags, -> { distinct }

  validates_presence_of :title
end
