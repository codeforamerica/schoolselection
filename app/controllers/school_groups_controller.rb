class SchoolGroupsController < ApplicationController
  # GET /school_groups
  # GET /school_groups.json
  def index
    @school_groups = SchoolGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @school_groups }
    end
  end

  # GET /school_groups/1
  # GET /school_groups/1.json
  def show
    @school_group = SchoolGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @school_group }
    end
  end

  # GET /school_groups/new
  # GET /school_groups/new.json
  def new
    @school_group = SchoolGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @school_group }
    end
  end

  # GET /school_groups/1/edit
  def edit
    @school_group = SchoolGroup.find(params[:id])
  end

  # POST /school_groups
  # POST /school_groups.json
  def create
    @school_group = SchoolGroup.new(params[:school_group])

    respond_to do |format|
      if @school_group.save
        format.html { redirect_to @school_group, notice: 'School group was successfully created.' }
        format.json { render json: @school_group, status: :created, location: @school_group }
      else
        format.html { render action: "new" }
        format.json { render json: @school_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /school_groups/1
  # PUT /school_groups/1.json
  def update
    @school_group = SchoolGroup.find(params[:id])

    respond_to do |format|
      if @school_group.update_attributes(params[:school_group])
        format.html { redirect_to @school_group, notice: 'School group was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @school_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /school_groups/1
  # DELETE /school_groups/1.json
  def destroy
    @school_group = SchoolGroup.find(params[:id])
    @school_group.destroy

    respond_to do |format|
      format.html { redirect_to school_groups_url }
      format.json { head :ok }
    end
  end
end
