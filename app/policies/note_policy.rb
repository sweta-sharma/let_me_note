class NotePolicy
  attr_reader :user, :note

  def initialize(user, note)
    @user = user
    @note = note
  end

  def show?
    user.creator?(note) || user.can_read?(note)
  end

  def update?
    user.creator?(note) || user.can_write?(note)
  end

  def destroy?
    user.creator?(note) || user.can_delete?(note)
  end

  def share?
    user.creator?(note) || user.can_share?(note)
  end

  def unshare?
    user.creator?(note) || user.can_unshare?(note)
  end
end