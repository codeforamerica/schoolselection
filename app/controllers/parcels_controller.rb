class ParcelsController < ApplicationController
  # GET /parcels
  # GET /parcels.json
  def index
    @parcels = Parcel.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @parcels }
    end
  end

  # GET /parcels/1
  # GET /parcels/1.json
  def show
    @parcel = Parcel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @parcel }
    end
  end

  # GET /parcels/new
  # GET /parcels/new.json
  def new
    @parcel = Parcel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @parcel }
    end
  end

  # GET /parcels/1/edit
  def edit
    @parcel = Parcel.find(params[:id])
  end

  # POST /parcels
  # POST /parcels.json
  def create
    @parcel = Parcel.new(params[:parcel])

    respond_to do |format|
      if @parcel.save
        format.html { redirect_to @parcel, notice: 'Parcel was successfully created.' }
        format.json { render json: @parcel, status: :created, location: @parcel }
      else
        format.html { render action: "new" }
        format.json { render json: @parcel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /parcels/1
  # PUT /parcels/1.json
  def update
    @parcel = Parcel.find(params[:id])

    respond_to do |format|
      if @parcel.update_attributes(params[:parcel])
        format.html { redirect_to @parcel, notice: 'Parcel was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @parcel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parcels/1
  # DELETE /parcels/1.json
  def destroy
    @parcel = Parcel.find(params[:id])
    @parcel.destroy

    respond_to do |format|
      format.html { redirect_to parcels_url }
      format.json { head :ok }
    end
  end
end
