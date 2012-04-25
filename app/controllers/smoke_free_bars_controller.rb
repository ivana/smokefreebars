class SmokeFreeBarsController < ApplicationController

  respond_to :html, :json

  def index
    if params[:coords]
      @smoke_free_bars = Location.near params[:coords]
    else
      @smoke_free_bars = Location.all
    end

    respond_with @smoke_free_bars
  end

end
