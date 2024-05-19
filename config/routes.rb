Rails.application.routes.draw do
  resources :recipes, only: %i[index show] do
    collection do
      get :suggestions
    end
  end

  root 'recipes#index'
end
