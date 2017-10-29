class User < ApplicationRecord

  has_many :created_notes, class_name: 'Note'

  validates_presence_of :first_name, :email, :password_digest
  validates :email, uniqueness: true
  validates :password,
            length: { in: 6..40, message: 'can be between 6 and 40 in length.' },
            format: {
              with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{6,40}\z/,
              message: 'should atleast contain alphabets and numbers'
            }

  has_secure_password

  def shared_notes
    shared_notes_id = SharedNote.where(user_id: self.id).pluck(:note_id)
    Note.where(id: shared_notes_id)
  end

  def notes
    created_notes + shared_notes
  end

  def creator?(note)
    note.creator == self
  end

  def can_read?(note)
    shared_note = SharedNote.where(user_id: self.id, note_id: note.id).first
    return false if shared_note.blank?

    shared_note.read? || shared_note.write? || shared_note.owner?
  end

  def can_write?(note)
    shared_note = SharedNote.where(user_id: self.id, note_id: note.id).first
    return false if shared_note.blank?

    shared_note.write? || shared_note.owner?
  end

  def is_owner?(note)
    shared_note = SharedNote.where(user_id: self.id, note_id: note.id).first
    return false if shared_note.blank?

    shared_note.owner?
  end

  alias_method :can_delete?, :is_owner?
  alias_method :can_share?, :is_owner?
  alias_method :can_unshare?, :is_owner?
end
