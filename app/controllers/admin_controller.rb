class AdminsController < ApplicationController
  def show
    # REDIRECIT IF NOT LOGGED IN
    @locations = current_admin
  end
end