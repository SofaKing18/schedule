Rails.application.routes.draw do

  get '/:controller/:action'
  root to: 'static_page#main'
  devise_for :users
  resources :user_events
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
