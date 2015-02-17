class Facet
  def self.all
    %w{artist object materials_techniques materials techniques place location collection_code year_start year_end}
  end

  def self.lists
    %w{materials_techniques materials techniques}
  end
end
