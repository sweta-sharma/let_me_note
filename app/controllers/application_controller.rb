class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  include Pundit
  include ExceptionHandler

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end

  def user_not_authorized
    render json: { error: 'Not Authorized' }, status: 401
  end

  def format_user(user)
    {
      id:user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email
    }
  end

  def format_note(note)
    {
      id: note.id,
      title: note.title,
      content: note.content,
      updatedAt: note.updated_at,
      tags: note.tags.pluck(:name)
    }
  end

  def format_tag(tag)
    {
      id: tag.id,
      name: tag.name
    }
  end
end