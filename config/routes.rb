Rails.application.routes.draw do

  # root '/hendrix'

  resources :locations, param: :slug, path: "", :only => [:show] do
    resources :posts, :only => [:index, :create, :update, :delete] do
      post '/flag', to: 'posts#flag'
      resources :comments, :only => [:create, :update, :delete] do
        post '/flag', to: 'comments#flag'
      end
    end
  end

  # TO BE IMPLEMENTED LATER
  # get '/about' 

end
