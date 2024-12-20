Rails.application.routes.draw do
  get '/api/search', to: 'search#index'
end
