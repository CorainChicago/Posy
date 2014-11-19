class SessionsController < ApplicationController

  def new
    raise "LOGIN".inspect
  end

  def create
    admin = Admin.find_by(email: params[:email])
    if admin && admin.authenticate(params[:password])
      flash[:notice] = "You've been successfully logged in."
      session[:admin_id] = admin.id
      # REDIRECT
    else
      flash[:alert] = "Invalid password or email"
      render "new"
    end
  end

  def destroy
    session[:admin_id] = nil
    # REDIRECT
  end

end