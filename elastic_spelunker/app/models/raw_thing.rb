class RawThing < ActiveRecord::Base
  self.table_name = 'va_collection_museumobject'

  def object_type
    self['object']
  end
end
