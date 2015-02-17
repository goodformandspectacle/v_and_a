ElasticSpelunker::Application.routes.draw do
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

  get 'completeness/:start/:end', to: 'sketches#completeness'
  get 'completeness', to: 'sketches#completeness', as: 'completeness'

  resource :about, :controller => 'about'

  # new facet replacements
  #resources :errors do
    #collection do
      #get :not_found
    #end
  #end

  # custom errors
  #match '/404', to: 'errors#not_found', via: :all
  
  

  root to: 'facets#random_object'
end
