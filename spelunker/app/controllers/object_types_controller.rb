class ObjectTypesController < ApplicationController
  def index
    values = Thing.group(:object).pluck(:object)
    current_page = params[:page].to_i || 1
    per_page = 30
    @values = WillPaginate::Collection.create(current_page, per_page, values.length) do |pager|
      pager.replace values
    end
    start = per_page * (current_page-1)
    @object_types = values[start,per_page]
  end

  def show
    @things = Thing.where(object: URI.decode(params[:id])).paginate(page: params[:page])
  end
end
