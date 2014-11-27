Spelunker::Application.routes.draw do
  get 'facets/place', to: 'places#index'
  get 'facets/place/:id', to: 'places#show'
  #get 'facets/materials_techniques', to: 'materials_techniques#index'
  #get 'facets/materials_techniques/:id', to: 'materials_techniques#show'

  resources :facets do
    collection do
      get 'random_object'
    end
  end
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

  get 'completeness/:start/:end', to: 'sketches#completeness'
  get 'completeness', to: 'sketches#completeness', as: 'completeness'

  resource :about, :controller => 'about'

  # new facet replacements
  resources :places
  resources :materials_techniques

  root to: 'facets#random_object'
end
