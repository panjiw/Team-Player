Rails.application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
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
  #match '/edit_user',   to: 'users#edit',          via: 'post'
  #match '/settings',    to: 'static_pages#settings',      via: 'get'
 
  # user
  match '/find_user_email',        to: 'users#finduseremail',   via: 'post'
  match '/update_user',    to: 'users#update',        via: 'post'
  match '/edit_password',  to: 'users#edit_password',          via: 'post'
  match '/edit_username',  to: 'users#edit_username',          via: 'post'
  match '/edit_email',  to: 'users#edit_email',          via: 'post'
  match '/edit_name',  to: 'users#edit_name',          via: 'post'

  # groups
  match '/create_group', to: 'groups#create',      via: 'post'
  match '/view_groups', to: 'users#viewgroup', 	   via: 'get'
  match '/add_to_group', to: 'groups#invitetogroup', via: 'post'
  match '/edit_group', to: 'groups#editgroup', via: 'post'
  match '/view_pending_groups', to: 'users#viewpendinggroups', via: 'get'
  match '/accept_group', to: 'groups#acceptgroup', via: 'post'
  match '/ignore_group', to: 'groups#ignoregroup', via: 'post'
  match '/leave_group', to: 'groups#leavegroup', via: 'post'

  match '/create_bill', to: 'bills#new', via: 'post'
  match '/get_bills', to: 'bills#get_all',   via: 'get'
  match '/get_bills_in_range', to: 'bills#get_in_range',   via: 'post'
  match '/finish_bill', to: 'bills#mark_finished', via: 'post'
  match '/edit_bill', to: 'bills#edit', via: 'post'
  match '/delete_bill', to: 'bills#delete', via: 'post'

  match '/run_generator', to: 'task_generators#create_new_task', via: 'post'

  match '/create_task', to: 'tasks#new', via: 'post'
  match '/get_tasks', to: 'tasks#get_all', via: 'get'
  match '/get_tasks_in_range',   to: 'tasks#get_in_range', via: 'post'
  match '/finish_task', to: 'tasks#mark_finished', via: 'post'
  match '/edit_task', to: 'tasks#edit', via: 'post'
  match '/delete_task', to: 'tasks#delete', via: 'post'

  match '/create_special_task', to: 'task_generators#new', via: 'post'
  match '/get_generators', to: 'task_generators#get_all', via: 'get'
  match '/get_generators_in_range', to: 'task_generators#get_in_range', via: 'get'
  match '/finish_special_task', to: 'task_generators#mark_finished', via: 'post'
  match '/edit_special_task', to: 'task_generators#edit', via: 'post'
  match '/delete_special_task', to: 'task_generators#delete', via: 'post'

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
