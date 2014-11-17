class Thing < ActiveRecord::Base
  self.table_name = 'va_collection_museumobject'

  # Dusen stuff
  search_syntax do
    search_by :text do |scope, phrases|
      columns = %w{Resume Extract}
      scope.where_like(columns => phrases)
    end
  end

  # counting stuff

  def self.number_with(field)
    self.where("#{field} != ''").count
  end

  def self.percentage_with(field)
    self.number_with(field).to_f / self.all.count * 100
  end

  def self.distinct_values_for(field)
    Thing.group(field).pluck(field)
  end

  def api_path
    "http://www.vam.ac.uk/api/json/museumobject/#{object_number}"
  end

  def image_url(size=nil)
    sizes = {small: 's',
             medium: 'm',
             large: 'l'}
    if size
      size_suffix = "_#{sizes[size]}"
    else
      size_suffix = ""
    end
    # http://media.vam.ac.uk/media/thira/collection_images/2009BX/2009BX7717_jpg_l.jpg 
    "http://media.vam.ac.uk/media/thira/collection_images/#{primary_image_id[0,6]}/#{primary_image_id}_jpg#{size_suffix}.jpg"
  end
end
