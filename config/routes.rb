Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/auth/login', to: 'authentication#login'
  post '/auth/signup', to: 'authentication#signup'
  put '/auth/password', to: 'authentication#change_password'
  post '/admin/interviews/create', to: 'interviews#create'
  post '/admin/interviews/update', to: 'interviews#update'
end
