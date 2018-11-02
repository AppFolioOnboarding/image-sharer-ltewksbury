Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :images do
    member do
      post 'share'
    end
  end

  root 'images#index'
end
