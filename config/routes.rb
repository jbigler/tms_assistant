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

  authenticated :user do
    root :to => 'dashboard#index'
  end
  root :to => "home#index"

  match 'admin' => 'admin/dashboard#index'

end
