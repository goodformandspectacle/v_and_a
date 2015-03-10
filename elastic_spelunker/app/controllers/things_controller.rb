class ThingsController < ApplicationController
  caches_action :index, cache_path: Proc.new {|c| c.request.url }, expires_in: 1.week
  caches_action :show, cache_path: Proc.new {|c| c.request.url }, expires_in: 1.week
  caches_action :list, cache_path: Proc.new {|c| c.request.url }, expires_in: 1.week

  def index
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
    index
    render :list
  end

  def show
    @thing = Thing.find(params[:id])
  end
end
