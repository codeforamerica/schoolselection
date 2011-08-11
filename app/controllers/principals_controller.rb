class PrincipalsController < ApplicationController
  # GET /principals
  # GET /principals.json
  def index
    @principals = Principal.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @principals }
    end
  end

  # GET /principals/1
  # GET /principals/1.json
  def show
    @principal = Principal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @principal }
    end
  end

  # GET /principals/new
  # GET /principals/new.json
  def new
    @principal = Principal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @principal }
    end
  end

  # GET /principals/1/edit
  def edit
    @principal = Principal.find(params[:id])
  end

  # POST /principals
  # POST /principals.json
  def create
    @principal = Principal.new(params[:principal])

    respond_to do |format|
      if @principal.save
        format.html { redirect_to @principal, notice: 'Principal was successfully created.' }
        format.json { render json: @principal, status: :created, location: @principal }
      else
        format.html { render action: "new" }
        format.json { render json: @principal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /principals/1
  # PUT /principals/1.json
  def update
    @principal = Principal.find(params[:id])

    respond_to do |format|
      if @principal.update_attributes(params[:principal])
        format.html { redirect_to @principal, notice: 'Principal was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @principal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /principals/1
  # DELETE /principals/1.json
  def destroy
    @principal = Principal.find(params[:id])
    @principal.destroy

    respond_to do |format|
      format.html { redirect_to principals_url }
      format.json { head :ok }
    end
  end
end
