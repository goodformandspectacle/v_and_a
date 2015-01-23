class ThingsController < ApplicationController
  caches_action :index, cache_path: Proc.new {|c| c.request.url }, expires_in: 1.week
  caches_action :show, cache_path: Proc.new {|c| c.request.url }, expires_in: 1.week
  caches_action :list, cache_path: Proc.new {|c| c.request.url }, expires_in: 1.week

  def index
    @things = Thing.paginate(page: params[:page])
  end

  def list
    @things = Thing.paginate(page: params[:page])
  end

  def show
    @thing = Thing.find(params[:id])
  end
end
