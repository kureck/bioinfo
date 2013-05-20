class DataFilesController < ApplicationController
  def index
  	@data_files = current_user.initial_inputs.data_files.all
  end

  def new
  	@data_file = DataFile.new(:initial_input_id => params[:initial_input_id])
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @data_file }
    end
  end

  def create
    header = DataFile.header(params[:data_file][:csvfile])
    params[:data_file][:header] = header
    @data_file = DataFile.new(params[:data_file])
    if @data_file.save
      flash[:notice] = "Successfully created Data File."
      redirect_to @data_file.initial_input
    else
      render :action => 'new'
    end
  end

  def edit
    @data_file = DataFile.find(params[:id])
  end

  def update
    @data_file = DataFile.find(params[:id])
    if @data_file.update_attributes(params[:data_file])
      flash[:notice] = "Successfully updated Data File."
      redirect_to @data_file.initial_input
    else
      render :action => 'edit'
    end
  end

  def destroy
    @data_file = DataFile.find(params[:id])
    @data_file.destroy
    flash[:notice] = "Successfully destroyed Data File."
    redirect_to @data_file.initial_input
  end
end
