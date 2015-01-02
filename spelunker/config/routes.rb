Spelunker::Application.routes.draw do
  get 'facets/place/:id', to: 'places#show', :id => /.+/
  get 'facets/place', to: 'places#index'
  get 'facets/materials/:id', to: 'materials#show', :id => /.+/
  get 'facets/materials', to: 'materials#index'
  get 'facets/techniques/:id', to: 'techniques#show', :id => /.+/
  get 'facets/techniques', to: 'techniques#index'
  get 'facets/materials_techniques/:id', to: 'materials_techniques#show', :id => /.+/
  get 'facets/materials_techniques', to: 'materials_techniques#index'
  get 'facets/artist/:id', to: 'artists#show', :id => /.+/ 
  get 'facets/artist', to: 'artists#index'

  get 'facets/:facet_id/:id', to: 'facets#things', as: :facet_thing
  resources :facets do
    collection do
      get 'random_object'
    end
  end

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

  get 'completeness/:start/:end', to: 'sketches#completeness'
  get 'completeness', to: 'sketches#completeness', as: 'completeness'

  resource :about, :controller => 'about'

  # new facet replacements
  resources :places
  resources :materials_techniques
  resources :materials
  resources :techniques
  resources :artists

  resources :errors do
    collection do
      get :not_found
    end
  end

  # custom errors
  get "/404", :to => "errors#not_found"
  

  root to: 'facets#random_object'
end
