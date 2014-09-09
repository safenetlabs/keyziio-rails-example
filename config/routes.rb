Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users, :controllers => {:sessions => 'sessions'}
  resources :users
  resources :posts, except: [:show]

  get 'safenet_labs_repository' => redirect('https://github.com/safenetlabs')

end
