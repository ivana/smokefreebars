require 'open-uri'
require 'json'
require 'nibbler/json'
# require 'active_support/core_ext'

class FsqBar < NibblerJSON
  element :id
  element :name
  element '.location.address' => :address
  element '.location.lat' => :lat
  element '.location.lng' => :lng

  def self.all
    fsq_request_params = {
      client_id: Rails.application.config.fsq.client_id,
      client_secret: Rails.application.config.fsq.client_secret,
      v: '20120206'
    }
    fsq_list_url = "https://api.foursquare.com/v2/lists/4f12e5b3e4b0042055da03f2?#{fsq_request_params.to_query}"
    bar_list = FsqList.parse open(fsq_list_url).read

    bar_list.venues
  end
end

class FsqList < NibblerJSON
  elements '.response.list.listItems.items.venue' => :venues, :with => FsqBar
end
