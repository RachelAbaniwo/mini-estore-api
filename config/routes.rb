Rails.application.routes.draw do
  # STRIPE
  post '/stripe/charge', to: 'billings#charge', as: 'stripe_charge'

  # ORDERS
  resources :orders, only: [:create]
  get '/orders/inCustomer', to: 'orders#index', as: 'get_customer_orders'
  get '/orders/:order_id', to: 'orders#show', as: 'get_order_list'
  get '/orders/shortDetail/:order_id', to: 'orders#order_detail', as: 'get_order_details'
  
  # SHIPPING
  get '/shipping/regions', to: 'shipping_regions#index', as: 'get_shipping_regions'
  get '/shipping/regions/:shipping_region_id', to: 'shipping_regions#show', as: 'get_region_shippings'

  #TAXES
  get '/tax', to: 'taxes#index', as: 'get_all_taxes'
  get '/tax/:tax_id', to: 'taxes#show', as: 'get_tax'

# SHOPPING CART
  get '/shoppingcart/generateUniqueId', to: 'shopping_carts#generate_unique_id', as: 'generate_cart_id'
  get '/shoppingcart/:cart_id', to: 'shopping_carts#show', as: 'get_cart_products'
  get '/shoppingcart​/saveForLater/:item_id', to: 'shopping_carts#save_for_later', as: 'save_item'
  get '/shoppingcart​/moveToCart/:item_id', to: 'shopping_carts#move_to_cart', as: 'move_to_cart'
  get '/shoppingcart/totalAmount/:cart_id', to: 'shopping_carts#total_amount', as: 'total_cart_amount'
  get '/shoppingcart/getSaved/:cart_id', to: 'shopping_carts#get_saved', as: 'get_saved'
  post '/shoppingcart/add', to: 'shopping_carts#add', as: 'add_to_cart'
  put '/shoppingcart/update/:item_id', to: 'shopping_carts#update', as: 'update_cart_item'
  delete '/shoppingcart/empty/:cart_id', to: 'shopping_carts#destroy', as: 'empty_cart'
  delete '/shoppingcart/removeProduct/:item_id', to: 'shopping_carts#remove_cart_item', as: 'remove_from_cart'
  
# CUSTOMERS
  post '/customers', to: 'customers#create', as: 'create_customer'
  post 'customers/login', to: 'authentication#login', as: 'login_customer'
  get '/customer', to: 'customers#show', as: 'get_customer'
  put '/customer', to: 'customers#update', as: 'update_customer'
  put 'customers/address', to: 'customers#update_address', as: 'update_customer_address'
  put 'customers/creditCard', to: 'customers#update_credit_card', as: 'update_credit_card'
  post 'customers/facebook', to: 'authentication#facebook_login', as: 'facebook_login'

  # PRODUCTS
  resources :products, only: [:index]
  get '/products/search', to: 'products#search_products', as: 'search_products'
  get '/products/:product_id', to: 'products#show', as: 'get_product'
  get '/products/inCategory/:category_id', to: 'products#get_products_in_category', as: 'products_in_category'
  get '/products/inDepartment/:department_id', to: 'products#get_products_in_department', as: 'products_in_department'
  get '/products/:product_id/details', to: 'products#get_product_details', as: 'product_details'
  get '/products/:product_id/locations', to: 'products#get_product_locations', as: 'product_locations'
  post '/products/:product_id/reviews', to: 'products#add_review', as: 'add_review'
  get '/products/:product_id/reviews', to: 'products#get_reviews', as: 'get_reviews'

  # ATTRIBUTES
  resources :attributes, only: [:index]
  get '/attributes/:attribute_id', to: 'attributes#show', as: 'get_attribute'
  get '/attributes/values/:attribute_id', to: 'attributes#get_attribute_values', as: 'attribute_values'
  get '/attributes/inProduct/:product_id', to: 'attributes#get_product_attributes', as: 'product_attributes'

  #CATEGORIES
  resources :categories, only: [:index]
  get '/categories/:category_id', to: 'categories#show', as: 'get_category'
  get '/categories/inProduct/:product_id', to: 'categories#get_product_category', as: 'product_category'
  get '/categories/inDepartment/:department_id', to: 'categories#get_department_categories', as: 'department_categories'

  # DEPARTMENTS
  resources :departments, only: [:index]
  get '/departments/:department_id', to: 'departments#show', as: 'get_department'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
