Rails.application.routes.draw do

  # root '/hendrix'

  get '/:slug/admin', to: 'locations#admin', as: 'location_admin'
  resources :locations, param: :slug, path: "", :only => [:show] do

    resources :posts, :only => [:index, :create, :destroy] do
      post '/flag', to: 'posts#flag'
      post '/clear', to: 'posts#clear'

      resources :comments, :only => [:create, :destroy] do
        post '/flag', to: 'comments#flag'
        post '/clear', to: 'comments#clear'
      end
    end
  end

  # TO BE IMPLEMENTED LATER
  # get '/about' 

end
