class UsersController < ApplicationController

  skip_before_action :authenticate_request, only: %i[login register]

  def register
    user = User.create(user_params)
    if user.save
      response = { message: 'User created successfully'}
      render json: response, status: :created
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
               message: 'Login Successful'
             }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

  def format_user(user)
    {
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email
    }
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
