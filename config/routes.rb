Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get 'welcome/index'
  root 'welcome#index'

  resources :locations
  resources :meetings
  resources :reviews

  resources :users do
    member do
      post 'send_friend_request'
      patch 'accept_friend_request'
      put 'accept_friend_request'
      delete 'delete_friend'
    end
  end

  get '/friend_requests', to: 'users#friend_requests'
  get '/users/:id/events', to: 'sessions#get_events'

  get '/redirect', to: 'calendar#redirect', as: 'redirect'
  get '/callback', to: 'calendar#callback', as: 'callback'

  get '/calendars', to: 'calendar#calendars', as: 'calendars'

  post '/events/primary', to: 'calendar#new_event', as: 'new_event', calendar_id: /[^\/]+/

  get '/events/:calendar_id', to: 'calendar#events', as: 'events', calendar_id: /[^\/]+/



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
