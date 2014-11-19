class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_admin
    @admin ||= Admin.find_by(id: current_admin_id) if current_admin_id
  end

  def current_admin_id
    session[:admin_id]
  end

end
