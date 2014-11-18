class Thing < ActiveRecord::Base
  self.table_name = 'va_collection_museumobject'

  # Dusen stuff
  search_syntax do
    search_by :text do |scope, phrases|
      columns = ["artist", "attributions_note", "bibliography", "credit", "descriptive_line", "event_text", "exhibition_history", "gallery", "historical_context_note", "historical_significance", "history_note", "label", "location", "marks", "materials", "materials_techniques", "object", "physical_description", "place", "production_note", "production_type", "public_access_description", "techniques", "title", "vanda_exhibition_history", "year_end", "year_start"]
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

  def has_image?
    !primary_image_id.blank?
  end

  def image_url(size=nil)
    sizes = {small: 's',
             medium: 'm',
             large: 'l'}
    if size
      size_suffix = "_jpg_#{sizes[size]}"
    else
      size_suffix = ""
    end
    # http://media.vam.ac.uk/media/thira/collection_images/2009BX/2009BX7717_jpg_l.jpg 
    "http://media.vam.ac.uk/media/thira/collection_images/#{primary_image_id[0,6]}/#{primary_image_id}#{size_suffix}.jpg"
  end

  def completeness
    fields = Thing.attribute_names
    total = fields.size

    filled_out_fields = fields.select {|f| !self.send(f).blank?}
    filled_out_fields.size.to_f / total
  end
end
