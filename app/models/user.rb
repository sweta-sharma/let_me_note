class User < ApplicationRecord

  has_many :created_notes, class_name: 'Note'

  validates_presence_of :first_name, :email, :password_digest
  validates :email, uniqueness: true
  validates :password_digest,
            length: { in: 6..40, message: 'can be between 6 and 40 in length.' },
            format: {
              with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{6,40}\z/,
              message: 'should atleast contain alphabets and numbers'
            }

  has_secure_password

  def creator?(note)
    note.creator == self
  end
end
