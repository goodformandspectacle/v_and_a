class ThingsController < ApplicationController
  caches_action :index, :cache_path => Proc.new {|c| c.request.url }
  caches_action :show, :cache_path => Proc.new {|c| c.request.url }
  caches_action :list, :cache_path => Proc.new {|c| c.request.url }

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
