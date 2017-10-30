class SharedNote < ApplicationRecord
  validates_presence_of :permission, :user_id, :note_id
end
