class ThingsController < ApplicationController

  def index

    set_cache_header(60 * 10)

    if params[:page]
      @current_page = params[:page].to_i
    else
      @current_page = 1
    end

    begin
      @things, @total_pages = Thing.paginate(@current_page, 20)
      @total_count = Thing.count_all
      @things_to_paginate = WillPaginate::Collection.new(@current_page, 20, @total_count)
    rescue Faraday::TimeoutError, Faraday::ConnectionFailed
      @things, @total_pages = [], 0
      @elasticsearch_error = "There was an error connecting to Elasticsearch, and results cannot be shown."
    rescue Elasticsearch::Transport::Transport::Errors::NotFound
      @things, @total_pages = [], 0
      @total_count = 0
    end
  end

  def list
    set_cache_header(60 * 10)

    index
    render :list
  end

  def show
    set_cache_header(60 * 10)
    
    @thing = Thing.find(params[:id])
  end
  
end
