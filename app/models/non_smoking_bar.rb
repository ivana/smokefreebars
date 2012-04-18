class NonSmokingBar
  include Mongoid::Document
  include Mongoid::Spacial::Document

  # id is the same as the 4sq id
  field :name, type: String
  field :address, type: String
  field :coords, type: Array, spacial: true

  validates_presence_of :name, :coords

  spacial_index :coords
end

# This model's purpose is:
#
#   1. to store attributes fetched from foursquare
#   2. to enable mongodb spacial indexing for determining nearest
#   3. to store after-save edited values of foursquare attributes, mainly corrections of wrong Croatian spellings
