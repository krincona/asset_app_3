Rails.application.routes.draw do

  mount RailsEmailPreview::Engine, at: 'emails'
  devise_for :users

  get 'static/home_tutor'

  get 'static/home'

  get 'static/home_parent'

  get 'static/board'

  root 'static#home'


  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :tutors,  path_names:{sign_in:'login',sign_out:'logout',sign_up:'register'}

  #resources :tutorias

  #match 'tutorias/relist' => 'tutorias#relist', via: [:get, :post]


  get "orders/form" => 'orders#form ', :as => :student_form

  resources :students do
    resources :comments
    member do
      get 'calendar'
    end
  end
  resources :tutoria_instances

  resources :orders do
    resources :materias
    member do
      get 'find_tutor'
    end
  end

  resources :materias do
    member do
      get 'tutor_postulation'
    end
  end

  resources :materia_instances

  resources :parents do
    member do
      get 'parent_calendar'
    end
  end

  resources :horarios

  resources :tutors do
    member do
      get 'profile'
    end
    member do
      get 'account'
    end
    member do
      get 'account_acceptance'
    end
    member do
      get 'list'
    end
    collection do
      get 'recal'
    end
  end

  resources :tutorias do
    member do
      get 'postulate'
    end
    collection do
      get 'relist'
    end
  end



  ActiveAdmin.routes(self)



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


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
