Spelunker::Application.routes.draw do
  resources :things
  resources :object_types
  resource :search, :controller => "search" do
    member do
      get 'results'
    end
  end
end
