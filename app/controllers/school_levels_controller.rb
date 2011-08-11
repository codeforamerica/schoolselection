class SchoolLevelsController < ApplicationController
  # GET /school_levels
  # GET /school_levels.json
  def index
    @school_levels = SchoolLevel.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @school_levels }
    end
  end

  # GET /school_levels/1
  # GET /school_levels/1.json
  def show
    @school_level = SchoolLevel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @school_level }
    end
  end

  # GET /school_levels/new
  # GET /school_levels/new.json
  def new
    @school_level = SchoolLevel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @school_level }
    end
  end

  # GET /school_levels/1/edit
  def edit
    @school_level = SchoolLevel.find(params[:id])
  end

  # POST /school_levels
  # POST /school_levels.json
  def create
    @school_level = SchoolLevel.new(params[:school_level])

    respond_to do |format|
      if @school_level.save
        format.html { redirect_to @school_level, notice: 'School level was successfully created.' }
        format.json { render json: @school_level, status: :created, location: @school_level }
      else
        format.html { render action: "new" }
        format.json { render json: @school_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /school_levels/1
  # PUT /school_levels/1.json
  def update
    @school_level = SchoolLevel.find(params[:id])

    respond_to do |format|
      if @school_level.update_attributes(params[:school_level])
        format.html { redirect_to @school_level, notice: 'School level was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @school_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /school_levels/1
  # DELETE /school_levels/1.json
  def destroy
    @school_level = SchoolLevel.find(params[:id])
    @school_level.destroy

    respond_to do |format|
      format.html { redirect_to school_levels_url }
      format.json { head :ok }
    end
  end
end
