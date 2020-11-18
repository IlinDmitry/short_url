Rails.application.routes.draw do
  resources :urls
  resources :urls, param: :short_url, only: [:create, :show] do
    member do
      get 'stats'
    end
  end
end
