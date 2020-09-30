Rails.application.routes.draw do
  

  get 'main_menu/index'
  get 'registration/index'
  get 'registration/clear'
  # post 'registration/saveinfo'
  match "registration/saveinfo" => "registration#saveinfo", as: :registration_saveinfo, via: [:get, :post]

  get 'search/new'
  match "search/find" => "search#find", as: :search_find, via: [:get, :post]
  get 'search/clear'
  get 'search/show'
  get 'search/back'
  get 'search/delete'
  get 'search/update'
  match "search/save_updated_info" => "search#save_updated_info", as: :search_save_updated_info, via: [:get, :post]


  get 'admin/index' 
  match "admin/login" => "admin#login", as: :admin_login, via: [:get, :post] 
  match "admin/saveinfo" => "admin#saveinfo", as: :admin_saveinfo, via: [:get, :post]


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root 'registration#index'
  # root 'search#new'
  root 'main_menu#index'
end
