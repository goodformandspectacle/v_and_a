class FacetsController < ApplicationController

  def index
    set_cache_header(60 * 10)

    @facets = Facet.all
  end

  def show
    set_cache_header(60 * 10)

    @facet = params[:id]

    values = Thing.counts_for_facet(@facet)

    @count = values.size
    if params[:page]
      current_page = params[:page].to_i
    else
      current_page = 1
    end
    per_page = 20
    @values = WillPaginate::Collection.create(current_page, per_page, values.length) do |pager|
      pager.replace values
    end

    start = per_page * (current_page-1)
    @facet_vals = values[start,per_page]

  end

  def things
    set_cache_header(60 * 10)

    if params[:page]
      @current_page = params[:page].to_i
    else
      @current_page = 1

    end
    begin
      @things, @total_pages = Thing.with_facet(params[:facet_id], params[:id], @current_page, 20)
      @total_count = Thing.count_with_facet(params[:facet_id], params[:id])
      @things_to_paginate = WillPaginate::Collection.new(@current_page, 20, @total_count)
    rescue Faraday::TimeoutError, Faraday::ConnectionFailed
      @rows, @total_pages = [], 0
      @elasticsearch_error = "There was an error connecting to Elasticsearch, and results cannot be shown."
    rescue Elasticsearch::Transport::Transport::Errors::NotFound
      @rows, @total_pages = [], 0
      @total_count = 0
    end
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
    @things = Thing.of_object_type(@object_type).select {|t| t.primary_image_id != ""}
    length = rand(5) +7 
    @things = @things.sort_by { rand }[0,length]
    while @things.size == 0
      @object_type = object_types.sort_by { rand }.first
      @things = Thing.of_object_type(@object_type).select {|t| t.primary_image_id != ""}
      length = rand(5) +7 
      @things = @things.sort_by { rand }[0,length]
    end
  end
end
