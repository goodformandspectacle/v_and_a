class ErrorsController < ApplicationController
  def not_found
    # 404 error
    objects = JSON.parse(File.read(Rails.root.join('lib', 'interesting_objects.json')))
    @object_id, @object_text = objects.sort_by { rand }.first
  end
end
