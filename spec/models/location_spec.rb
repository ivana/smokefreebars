require 'spec_helper'
require 'ostruct'

describe Location do

  before(:each) do
    SavedLocation.delete_all
  end

  it "pulls from foursquare" do
    fake_location = OpenStruct.new id: 'abcd1234', name: 'Fake Venue', address: 'Fake St. 62', lat: 42, lng: 16
    fake_foursquare = OpenStruct.new all: [fake_location]
    Location.foursquare_model = fake_foursquare

    locations = Location.all
    locations.size.should eq(1)
    locations.first.name.should eq('Fake Venue')
  end

  it "no more often than 5 minutes"
  it "backs up locations to database"
  it "deletes old locations from database"

end