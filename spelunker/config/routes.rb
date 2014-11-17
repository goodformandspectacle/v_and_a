Spelunker::Application.routes.draw do
  resources :facets
  get 'facets/:facet_id/:id', to: 'facets#things', as: :facet_thing

  resources :things
  resource :search, :controller => "search" do
    member do
      get 'results'
    end
  end

  root to: 'things#index'
end
