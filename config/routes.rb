Rails.application.routes.draw do

  # IMPLEMENT ROOT
  root 'locations#show', slug: 'hendrix'

  get '/admin',  to: "admins#show"
  get '/login',  to: "sessions#new"
  post '/login', to: "sessions#create"
  get '/logout', to: "sessions#destroy"
  get '/:slug/admin', to: 'locations#admin', as: 'location_admin'

  resources :locations, param: :slug, path: "", :only => [:show] do

    resources :posts, :only => [:index, :create, :destroy] do
      post '/flag',  to: 'posts#flag'
      post '/clear', to: 'posts#clear'

      resources :comments, :only => [:create, :destroy] do
        post '/flag',  to: 'comments#flag'
        post '/clear', to: 'comments#clear'
      end
    end
  end

  # IMPLEMENT ABOUT

end
