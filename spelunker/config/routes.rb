Spelunker::Application.routes.draw do
  resources :things
  resource :search, :controller => "search" do
    member do
      get 'results'
    end
  end
end
