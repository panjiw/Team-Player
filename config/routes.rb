Rails.application.routes.draw do
  # All routes are manual because of the heavy use of Angular to view the correct
  # pages to the user
  # resources :users
  match '/',            to: 'static_pages#index',  via: 'get'
  match '/index',       to: 'static_pages#index',  via: 'get'
  match '/home',        to: 'static_pages#home',   via: 'get'
  match '/create_user', to: 'users#create',        via: 'post'
  match '/sign_in',     to: 'sessions#create',     via: 'post'
  match '/sign_out',    to: 'sessions#destroy',    via: 'delete'
  match '/user',        to: 'sessions#user',       via: 'get'
  match '/help',        to: 'static_pages#help',   via: 'get'

  # user
  match '/find_user_email',        to: 'users#finduseremail',   via: 'post'
  # groups
  match '/create_group', to: 'groups#create',      via: 'post'
  match '/view_group', to: 'users#viewgroup', 	   via: 'post'
  match '/view_members', to: 'groups#viewmembers', via: 'post'
  match '/invite_to_group', to: 'groups#invitetogroup', via: 'post'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
