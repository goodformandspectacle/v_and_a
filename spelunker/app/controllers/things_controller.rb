class ThingsController < ApplicationController
  def index
    @things = Thing.paginate(page: params[:page])
  end

  def show
    @thing = Thing.find(params[:id])
  end
end
