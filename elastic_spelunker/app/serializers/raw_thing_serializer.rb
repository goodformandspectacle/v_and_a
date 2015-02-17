class RawThingSerializer < ActiveModel::Serializer
  attributes :artist, :attributions_note, :bibliography, :collection_code, :credit, :date_end, :date_start, :date_text, :descriptive_line, :dimensions, :edition_number, :event_text, :exhibition_history, :gallery, :historical_context_note, :historical_significance, :history_note, :id, :label, :last_checked, :last_processed, :latitude, :location, :longitude, :marks, :materials, :materials_techniques, :museum_number, :museum_number_token, :object_type, :object_number, :on_display, :original_currency, :original_price, :physical_description, :place, :primary_image_id, :production_note, :production_type, :public_access_description, :related_museum_numbers, :rights, :shape, :site_code, :slug, :sys_updated, :techniques, :title, :updated, :vanda_exhibition_history, :year_end, :year_start

  def materials
    object['materials'].split(',').map {|m| m.strip} if object['materials']
  end

  def techniques
    object['techniques'].split(',').map {|m| m.strip} if object['techniques']
  end

  def materials_techniques
    object['materials_techniques'].split(',').map {|m| m.strip} if object['materials_techniques']
  end

end
