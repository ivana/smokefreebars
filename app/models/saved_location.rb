class SavedLocation
  include Mongoid::Document
  include Mongoid::Spacial::Document

  def self.collection_name() 'smoke_free_bars' end

  field :name, type: String
  field :address, type: String
  field :coords, type: Array, spacial: true # longitude latitude array in that order - [lng, lat]
  field :fsq_id, type: String # foursquare id != _id

  validates_presence_of :name, :coords, :fsq_id

  spacial_index :coords

  def self.near coords
    where(:coords.near => [coords])
  end

  def self.foursquare_ids
    all.map(&:fsq_id)
  end

  def self.delete_foursquare_ids ids
    where(:fsq_id.in => ids).delete_all
  end
  
  def self.each_missing_foursquare_location fsq_locations
    existing_ids = existing_foursquare_ids
    fsq_locations.each do |location|
      yield location
    end
  end
end
