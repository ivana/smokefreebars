require 'spec_helper'
require 'ostruct'

describe Location do

  before(:each) do
    Location.reset!
  end

  it "pulls from foursquare" do
    fake_location = OpenStruct.new id: 'abcd1234', name: 'Fake Venue', address: 'Fake St. 62', lat: 42, lng: 16
    fake_foursquare = OpenStruct.new all: [fake_location]
    Location.foursquare_model = fake_foursquare

    locations = Location.all
    locations.size.should eq(1)
    locations.first.name.should eq('Fake Venue')
  end

  it "performs sync no more often than 5 minutes" do
    fake_foursquare = double
    fake_foursquare.should_receive(:all).once.and_return([])
    Location.foursquare_model = fake_foursquare

    Location.all

    future_time = 4.minutes.from_now
    Time.stub(:now).and_return future_time
    Location.all
  end

  it "performs sync twice if 5 minutes have passed" do
    fake_foursquare = double
    fake_foursquare.should_receive(:all).twice.and_return([])
    Location.foursquare_model = fake_foursquare

    Location.all

    future_time = 6.minutes.from_now
    Time.stub(:now).and_return future_time
    Location.all
  end

  it "backs up locations to database" do
    fake_location = OpenStruct.new id: 'abcd1234', name: 'New Venue', address: 'Fake St. 62', lat: 42, lng: 16
    fake_foursquare = OpenStruct.new all: [fake_location]
    Location.foursquare_model = fake_foursquare

    Location.all

    locations = SavedLocation.all
    locations.size.should eq(1)
    locations.first.fsq_id.should eq('abcd1234')
    locations.first.coords.should include(lat: 42, lng: 16)
  end

  it "deletes old locations from database" do
    stale_location = SavedLocation.create! fsq_id: 'abcd7890', name: 'Smoking allowed', coords: { lat: 42, lng: 16 }
    SavedLocation.all.size.should eq(1)

    fake_foursquare = OpenStruct.new all: []
    Location.foursquare_model = fake_foursquare

    Location.all
    SavedLocation.all.size.should eq(0)
  end

  it "fetches by coordinates"

end
