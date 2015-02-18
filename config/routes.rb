Rails.application.routes.draw do

  root to: redirect('/hendrix')

  get   '/admin',         to: "admins#index"
  get   '/:slug/admin',   to: "admins#show",    as: "location_admin"

  get   '/login',         to: "sessions#new"
  post  '/login',         to: "sessions#create"
  get   '/logout',        to: "sessions#destroy"

  resources :locations, param: :slug, path: "", :only => [:show] do

    resources :posts, :only => [:index, :create, :destroy] do

      post '/flag',       to: 'posts#flag'
      post '/clear',      to: 'posts#clear'

      resources :comments, :only => [:create, :destroy] do

        post '/flag',     to: 'comments#flag'
        post '/clear',    to: 'comments#clear'

      end

    end
  end

end
