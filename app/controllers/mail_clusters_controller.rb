class MailClustersController < ApplicationController
  # GET /mail_clusters
  # GET /mail_clusters.json
  def index
    @mail_clusters = MailCluster.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mail_clusters }
    end
  end

  # GET /mail_clusters/1
  # GET /mail_clusters/1.json
  def show
    @mail_cluster = MailCluster.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mail_cluster }
    end
  end

  # GET /mail_clusters/new
  # GET /mail_clusters/new.json
  def new
    @mail_cluster = MailCluster.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mail_cluster }
    end
  end

  # GET /mail_clusters/1/edit
  def edit
    @mail_cluster = MailCluster.find(params[:id])
  end

  # POST /mail_clusters
  # POST /mail_clusters.json
  def create
    @mail_cluster = MailCluster.new(params[:mail_cluster])

    respond_to do |format|
      if @mail_cluster.save
        format.html { redirect_to @mail_cluster, notice: 'Mail cluster was successfully created.' }
        format.json { render json: @mail_cluster, status: :created, location: @mail_cluster }
      else
        format.html { render action: "new" }
        format.json { render json: @mail_cluster.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mail_clusters/1
  # PUT /mail_clusters/1.json
  def update
    @mail_cluster = MailCluster.find(params[:id])

    respond_to do |format|
      if @mail_cluster.update_attributes(params[:mail_cluster])
        format.html { redirect_to @mail_cluster, notice: 'Mail cluster was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @mail_cluster.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mail_clusters/1
  # DELETE /mail_clusters/1.json
  def destroy
    @mail_cluster = MailCluster.find(params[:id])
    @mail_cluster.destroy

    respond_to do |format|
      format.html { redirect_to mail_clusters_url }
      format.json { head :ok }
    end
  end
end
