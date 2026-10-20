Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "pages#home"
  # get "services", to: "pages#services", as: :services
  get "workshop", to: "pages#workshop", as: :workshop
  get "about", to: "pages#about", as: :about

  resources :customers
  resources :bikes
  resources :staff_members

  resources :repairs do
    resources :intake_photos, only: :destroy
  end

  resources :service_catalogs, path: "services"

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :services, only: [ :index, :show, :create ]
      resources :repairs, only: [ :index, :show ]
      match "*path", to: "base#route_not_found", via: :all
    end
  end
end
