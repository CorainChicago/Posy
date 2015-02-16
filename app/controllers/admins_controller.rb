class AdminsController < ApplicationController

  before_action :authenticate
  before_action :authenticate_administration, only: [:show]

  def index
    @locations = @admin.locations
  end

  def show
    # app/facades/admin_location.rb
    @admin = AdminLocation.new(@location)
  end



    private

  def authenticate
    @admin = current_admin
    unless @admin
      flash[:alert] = "You must be logged in."
      redirect_to login_path
    end
  end

  def authenticate_administration
    authenticate_location

    admin_ids = @location.admins.pluck(:id)
    redirect_to '/' unless admin_ids.include? @admin.id
  end

  def authenticate_location
    url = params[:slug].downcase.strip
    @location = Location.find_by(slug: url)
    redirect_to '/' unless @location
  end

end