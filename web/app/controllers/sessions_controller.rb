class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:show, :create]
  before_action :require_logout, only: [:show, :create]

  def show; end

  def create
    if login(login_params[:email], login_params[:password])
      redirect_to root_path
    else
      redirect_to root_path, notice: 'Usuario o contraseña invalido.'
    end
  end

  def destroy
    logout

    redirect_to root_path
  end
  private
  def login_params
    params.fetch(:login, {}).permit(:email, :password)
  end

  def require_logout
    return unless logged_in?

    redirect_to root_path
  end
end
