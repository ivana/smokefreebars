class FoursquareLocationSync
  attr_reader :fsq_locations, :location_model

  def initialize fsq_locations, location_model
    @fsq_locations = fsq_locations
    @location_model = location_model
  end

  def sync!
    add_missing_locations
    delete_stale_locations
  end


  private

  def add_missing_locations
    existing_ids = location_model.foursquare_ids

    fsq_locations.each do |location|
      unless existing_ids.include? location.id
        location_model.create! fsq_id: location.id, name: location.name, address: location.address, coords: { lat: location.lat, lng: location.lng }
      end
    end
  end

  def delete_stale_locations
    existing_ids = location_model.foursquare_ids
    fsq_ids = fsq_locations.map &:id
    ids_to_remove = existing_ids - fsq_ids

    location_model.delete_foursquare_ids ids_to_remove
  end
end
