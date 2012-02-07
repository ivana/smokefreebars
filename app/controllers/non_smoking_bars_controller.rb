class NonSmokingBarsController < ApplicationController

  before_filter :login_required, :except => [:index, :show]

  # GET /non_smoking_bars
  # GET /non_smoking_bars.json
  def index
    @non_smoking_bars = FsqBar.all

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

  # GET /non_smoking_bars/new
  # GET /non_smoking_bars/new.json
  def new
    @non_smoking_bar = NonSmokingBar.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @non_smoking_bar }
    end
  end

  # GET /non_smoking_bars/1/edit
  def edit
    @non_smoking_bar = NonSmokingBar.find(params[:id])
  end

  # POST /non_smoking_bars
  # POST /non_smoking_bars.json
  def create
    @non_smoking_bar = NonSmokingBar.new(params[:non_smoking_bar])

    respond_to do |format|
      if @non_smoking_bar.save
        format.html { redirect_to root_url, notice: 'Successfully created.' }
        format.json { render json: @non_smoking_bar, status: :created, location: @non_smoking_bar }
      else
        format.html { render action: "new" }
        format.json { render json: @non_smoking_bar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /non_smoking_bars/1
  # PUT /non_smoking_bars/1.json
  def update
    @non_smoking_bar = NonSmokingBar.find(params[:id])

    respond_to do |format|
      if @non_smoking_bar.update_attributes(params[:non_smoking_bar])
        format.html { redirect_to root_url, notice: 'Successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @non_smoking_bar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /non_smoking_bars/1
  # DELETE /non_smoking_bars/1.json
  def destroy
    @non_smoking_bar = NonSmokingBar.find(params[:id])
    @non_smoking_bar.destroy

    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Successfully deleted.' }
      format.json { head :ok }
    end
  end
end
