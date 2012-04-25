class SmokeFreeBarsController < ApplicationController

  # GET /smoke_free_bars
  # GET /smoke_free_bars.json
  def index
    sync_with_foursquare
    @smoke_free_bars = SmokeFreeBar.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @smoke_free_bars }
    end
  end

  def list
    render json: FsqBar.all
  end

  def list_by_nearest
    render json: SmokeFreeBar.where(:coords.near => [params[:coords]]) # mongoid_spacial query
  end

  private

  # synchronizes bars data in mongodb with the foursquare list
  def sync_with_foursquare
    # 1. fetch foursquare list and mongo data
    fsq_bars = FsqBar.all
    fsq_ids = fsq_bars.map &:id
    mongo_ids = SmokeFreeBar.all.map &:fsq_id

    # 2. delete bars missing in foursquare list from mongo
    removed_ids = mongo_ids - fsq_ids
    SmokeFreeBar.where(:fsq_id.in => removed_ids).delete_all

    # 3. save new bars in foursquare list to mongo
    added_ids = fsq_ids - mongo_ids # example: ["4d5d156d9895b1f76807ec0f", "4c6946383bad2d7ff65cafee"]
    added_ids.each { |fsq_id|
      new_bar = fsq_bars.select { |bar| bar.id == fsq_id }.first
      SmokeFreeBar.create! fsq_id: new_bar.id, name: new_bar.name, address: new_bar.address, coords: { lat: new_bar.lat, lng: new_bar.lng }
    }
  end
end
