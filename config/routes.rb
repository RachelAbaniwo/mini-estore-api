Rails.application.routes.draw do
  resources :products, only: [:index]
  get '/products/search', to: 'products#search_products', as: 'search_products'
  get '/products/:product_id', to: 'products#show', as: 'get_product'
  get '/products/inCategory/:category_id', to: 'products#get_products_in_category', as: 'products_in_category'
  get '/products/inDepartment/:department_id', to: 'products#get_products_in_department', as: 'products_in_department'
  get '/products/:product_id/details', to: 'products#get_product_details', as: 'product_details'
  get '/products/:product_id/locations', to: 'products#get_product_locations', as: 'product_locations'

  resources :attributes, only: [:index]
  get '/attributes/:attribute_id', to: 'attributes#show', as: 'get_attribute'
  get '/attributes/values/:attribute_id', to: 'attributes#get_attribute_values', as: 'attribute_values'
  get '/attributes​/inProduct​/:product_id', to: 'attributes#get_product_attributes', as: 'product_attributes'

  resources :categories, only: [:index]
  get '/categories/:category_id', to: 'categories#show', as: 'get_category'
  get '/categories/inProduct/:product_id', to: 'categories#get_product_category', as: 'product_category'
  get '/categories/inDepartment/:department_id', to: 'categories#get_department_categories', as: 'department_categories'

  resources :departments, only: [:index]
  get '/departments/:department_id', to: 'departments#show', as: 'get_department'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
