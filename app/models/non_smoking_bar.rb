class NonSmokingBar
  include Mongoid::Document

  field :name, type: String
  field :address, type: String
  # id is the same as the 4sq id

  validates_presence_of :name, :address
end
# this model's purpose is to store edited values of 4sq properties, mainly corrections of wrong Croatian spellings
