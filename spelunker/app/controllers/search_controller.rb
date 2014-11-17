class SearchController < ApplicationController
  def results
    @query = params[:query]
    @results = Thing.search(@query)
  end
end
