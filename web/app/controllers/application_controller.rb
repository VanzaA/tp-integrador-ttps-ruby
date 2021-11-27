class ApplicationController < ActionController::Base
  before_action :require_login, except: :healt_check

  def healt_check
    render plain: 'success', status: :ok
  end
  def home; end
  private

  def not_authenticated
    redirect_to session_path
  end
end
