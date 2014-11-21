class AdminsController < ApplicationController

  def show
    @admin = current_admin
    if @admin
      @locations = @admin.locations
    else
      flash[:alert] = "You must be logged in."
      redirect_to login_path
    end
  end

end