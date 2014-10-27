Rails.application.routes.draw do

  resources :locations,    :only => [] do
    resources :posts,      :only => [:index, :create, :update, :delete] do
      resources :comments, :only => [:create, :update, :delete] 
    end
  end

  # TO BE IMPLEMENTED LATER
  # get '/about' 

  get '/:location_name' => 'post#index', as: "location"

end
