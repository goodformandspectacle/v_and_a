class FacetsController < ApplicationController
  def index
    @facets = Facet.all
  end

  def show
    @facet = params[:id]

    values = Thing.group(@facet).count.to_a.sort_by{|v| v.last}.reverse
    if params[:page]
      current_page = params[:page].to_i
    else
      current_page = 1
    end
    per_page = 30
    @values = WillPaginate::Collection.create(current_page, per_page, values.length) do |pager|
      pager.replace values
    end
    start = per_page * (current_page-1)
    @facet_vals = values[start,per_page]

  end

  def things
    @things = Thing.where(params[:facet_id] => URI.decode(params[:id])).paginate(page: params[:page])
    "/facets/materials_tecniques/whatever"
  end
end
