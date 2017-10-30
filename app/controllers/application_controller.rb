class ApplicationController < ActionController::API

  protect_from_forgery

  before_action :authenticate_request
  attr_reader :current_user

  include Pundit
  include ExceptionHandler

  private
  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end