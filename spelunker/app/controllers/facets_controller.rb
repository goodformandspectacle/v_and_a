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
  end

  def random_object
    object_types = ['Print',
                    'photograph',
                    'Drawing',
                    'Fashion design',
                    'Poster',
                    'Woodblock print',
                    'Design',
                    'Object',
                    'Painting',
                    'Sample',
                    'Photographic negative',
                    'Wallpaper',
                    'Furnishing fabric',
                    'Fragment',
                    'Watercolour',
                    'Tile',
                    'Costume design',
                    'Page',
                    'Textile design',
                    'Brass rubbing',
                    'Vase',
                    'Dish',
                    'Sketchbook',
                    'Bowl',
                    'Plate',
                    'Model',
                    'Border',
                    'Panel',
                    "Figure"]

    @object_type = object_types.sort_by { rand }.first
    @things = Thing.where(object: @object_type).limit(10).select {|t| t.primary_image_id != ""}
  end
end
