class SessionsController < ApplicationController

  def new
    redirect_to admin_path if current_admin_id
  end

  def create
    admin = Admin.find_by(email: params[:email])
    if admin && admin.authenticate(params[:password])
      flash[:notice] = "You've been successfully logged in."
      session[:admin_id] = admin.id
      redirect_to admin_path
    else
      flash[:alert] = "Invalid password or email"
      render "new"
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to login_path
  end

end