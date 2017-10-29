class UsersController < ApplicationController

  skip_before_action :authenticate_request, only: %i[login register]

  def index
    render json: {
             users: User.all.map{ |user| format_user(user) }
           }
  end

  def register
    user = User.create(user_params)
    if user.save
      authenticate params[:email], params[:password]
    else
      render json: user.errors, status: :bad
    end
  end

  def login
    authenticate params[:email], params[:password]
  end

  def details
    render json: {
             user: format_user(current_user)
           }
  end

  private

  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)

    if command.success?
      render json: {
               access_token: command.result,
               user: format_user(User.find_by_email(email)),
               message: 'Login Successful'
             }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

  def user_params
    params.permit(
      :first_name,
      :last_name,
      :email,
      :password
    )
  end
end
