Rails.application.routes.draw do
  resources :categories, only: [:index, :show]
  get '/categories/inDepartment/:id', to: 'categories#get_department_categories', as: 'department_categories'

  resources :departments, only: [:index, :show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
