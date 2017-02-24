Rails.application.routes.draw do
  devise_for :workers
  devise_for :users
  root 'landing#index'

  resources :jobs
  resources :workers

  get 'jobs/:id/active' => 'jobs#active', as: 'active'
  get 'jobs/:id/complete' => 'jobs#complete', as: 'complete'
end
