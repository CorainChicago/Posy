Rails.application.routes.draw do

  # root '/hendrix'

  resources :locations, param: :slug, path: "", :only => [:show] do
    resources :posts, :only => [:index, :create, :update, :delete] do
      resources :comments, :only => [:create, :update, :delete] 
    end
  end

  # TO BE IMPLEMENTED LATER
  # get '/about' 


end
