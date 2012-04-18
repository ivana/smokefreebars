class NonSmokingBarsController < ApplicationController

  # GET /non_smoking_bars
  # GET /non_smoking_bars.json
  def index
    @non_smoking_bars = FsqBar.all

    @non_smoking_bars.each { |fsq_bar|
      if NonSmokingBar.exists? conditions: {id:fsq_bar.id}
        edited = NonSmokingBar.find fsq_bar.id
        fsq_bar.name = edited.name
        fsq_bar.address = edited.address
      end
    }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @non_smoking_bars }
    end
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

end
