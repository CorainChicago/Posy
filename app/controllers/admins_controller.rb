class AdminsController < ApplicationController

  def show
    # PRODUCTION ONLY
    session[:admin_id] = Admin.find_by(email: "dev@dev.com").id
    # END PRODUCTION ONLY

    @admin = current_admin
    if @admin
      @locations = @admin.locations
    else
      notice[:alert] = "You must be logged in."
      redirect_to login_path
    end
  end

end