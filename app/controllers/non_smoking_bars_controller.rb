class NonSmokingBarsController < ApplicationController

  # GET /non_smoking_bars
  # GET /non_smoking_bars.json
  def index
    sync_with_foursquare
    @non_smoking_bars = NonSmokingBar.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @non_smoking_bars }
    end
  end

  def list
    render json: FsqBar.all
  end

  def list_by_nearest
    render json: NonSmokingBar.where(:coords.near => [params[:coords]]) # mongoid_spacial query
  end

  # GET /non_smoking_bars/1
  # GET /non_smoking_bars/1.json
  def show
    @non_smoking_bar = NonSmokingBar.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @non_smoking_bar }
    end
  end


  private

  # synchronizes bars data in mongodb with the foursquare list
  def sync_with_foursquare
    # 1. fetch foursquare list and mongo data
    fsq_bars = FsqBar.all
    fsq_ids = fsq_bars.map &:id
    mongo_ids = NonSmokingBar.all.map &:fsq_id

    # 2. delete bars missing in foursquare list from mongo
    removed_ids = mongo_ids - fsq_ids
    NonSmokingBar.where(:fsq_id.in => removed_ids).delete_all

    # 3. save new bars in foursquare list to mongo
    added_ids = fsq_ids - mongo_ids # example: ["4d5d156d9895b1f76807ec0f", "4c6946383bad2d7ff65cafee"]
    added_ids.each { |fsq_id|
      new_bar = fsq_bars.select { |bar| bar.id == fsq_id }.first
      NonSmokingBar.create! fsq_id: new_bar.id, name: new_bar.name, address: new_bar.address, coords: { lat: new_bar.lat, lng: new_bar.lng }
    }
  end
end
