Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"

  mount DeviseSecurePassword::Engine => "/devise_secure_password"
end
