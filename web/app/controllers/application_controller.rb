class ApplicationController < ActionController::Base
  before_action :require_login

  def home; end
  private

  def not_authenticated
    redirect_to session_path
  end
end
