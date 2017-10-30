class NotePolicy
  attr_reader :user, :note

  def initialize(user, note)
    @user = user
    @note = note
  end

  def show
    user.creator?(note)
  end

  def update
    user.creator?(note)
  end

  def destroy
    user.creator?(note)
  end

  def share
    user.creator?(note)
  end
end