require 'active_support/core_ext'

# A generic domain layer that pulls data from multiple sources.
#
# - originally fetches from Foursquare
# - caches records to database
# - enables fetch by coordinates
module Location
  SYNC_INTERVAL = 5.minutes

  class << self
    attr_accessor :foursquare_model
  end
  self.foursquare_model = FsqBar

  def self.all
    sync_with_foursquare if perform_sync?
    SavedLocation.all
  end

  def self.near coords
    SavedLocation.near coords
  end

  def self.sync_with_foursquare
    synchronizer = FoursquareLocationSync.new(foursquare_model.all, SavedLocation)
    synchronizer.sync!
    @last_synced_at = Time.now
  end

  def self.perform_sync?
    !defined? @last_synced_at or @last_synced_at < SYNC_INTERVAL.ago
  end
end
