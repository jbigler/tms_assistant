TmsAssistant::Application.routes.draw do

  devise_for :users

  get "dashboard/index"

  namespace "admin" do
    resources :users
    resources :languages
  end

  resources :users do
    member do
      get 'set_default_congregation'
    end
  end

  resources :congregations do
    resources :special_dates do
      collection do
        get 'update_calendar'
      end
    end

    resources :students do
      resources :unavailable_dates
    end
    resources :families
    resources :school_sessions do
      collection do
        get :update_calendar
      end
      member do
        get :complete
        put :finalize
      end
    end
    match 'reports/show' => 'reports#show', :via => :get, :format => :pdf
  end

  resources :languages do
    resources :lesson_sources
    resources :setting_sources
    resources :schedules do
      collection do
        get :update_calendar
      end
    end
  end

  root :to => 'dashboard#index'

  match 'admin' => 'admin/dashboard#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
