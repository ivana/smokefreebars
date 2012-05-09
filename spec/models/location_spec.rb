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
    old_location_saved = SavedLocation.create! fsq_id: 'abcd1235', name: 'Old Venue', address: 'Fake St. 61', coords: { lat: 43, lng: 16 }

    locations = SavedLocation.all
    locations.size.should eq(1)
    locations.should include(old_location_saved)

    old_location = OpenStruct.new id: 'abcd1235', name: 'Old Venue', address: 'Fake St. 61', lat: 43, lng: 16
    new_location = OpenStruct.new id: 'abcd1234', name: 'New Venue', address: 'Fake St. 62', lat: 42, lng: 16
    fake_foursquare = OpenStruct.new all: [old_location, new_location]
    Location.foursquare_model = fake_foursquare

    Location.all

    locations = SavedLocation.all
    locations.size.should eq(2)
    locations.map(&:fsq_id).should include(old_location.id, new_location.id)
  end

  it "deletes old locations from database" do
    smokefree = OpenStruct.new id: 'abcd1235', name: 'Smoke-free bar', lat: 43, lng: 16
    fake_foursquare = OpenStruct.new all: [smokefree]
    Location.foursquare_model = fake_foursquare

    stale_location = SavedLocation.create! fsq_id: 'abcd7890', name: 'Smoking allowed', coords: { lat: 42, lng: 16 }
    smokefree_saved = SavedLocation.create! fsq_id: 'abcd1235', name: 'Smoke-free bar', coords: { lat: 43, lng: 16 }
    SavedLocation.all.size.should eq(2)

    Location.all

    locations = SavedLocation.all
    locations.size.should eq(1)
    locations.should include(smokefree_saved)
    locations.should_not include(stale_location)
  end

end
