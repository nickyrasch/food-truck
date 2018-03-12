Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "home#index"

  resources :trucks

  scope "api" do
    scope "v1" do
      resources :trucks
      # todo resources :menu_items
    end
  end
end
