class ApplicationController < ActionController::Base
  before_action :require_login

  def home; end
  private

  def not_authenticated
    redirect_to session_path
  end

  rescue_from ActionPolicy::Unauthorized do |ex|
    render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
  end
end
