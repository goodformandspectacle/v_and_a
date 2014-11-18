Spelunker::Application.routes.draw do
  resources :facets
  get 'facets/:facet_id/:id', to: 'facets#things', as: :facet_thing

  resources :things do
    collection do
      get 'list'
    end
  end
  resource :search, :controller => "search" do
    member do
      get 'results'
    end
  end

  resources :sketches do
    collection do
      get 'completeness'
    end
  end

  root to: 'things#index'
end
