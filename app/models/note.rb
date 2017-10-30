class Note < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  has_many :tags

  validates_presence_of :title
end
