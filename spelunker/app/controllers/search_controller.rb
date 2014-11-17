class SearchController < ApplicationController
  def results
    @query = params[:query]
    @things = Thing.search(@query).paginate(page: params[:page])
  end
end
