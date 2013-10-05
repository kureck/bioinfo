# encoding: UTF-8
class MergeFilesController < ApplicationController
    def index

    end

    def new
      @data_files = DataFile.find(params[:ids])
      @count = 12/@data_files.count
      @merge_file = MergeFile.new
    end

  	def create
      @merge_file = current_user.merge_files.build(params)
      files = DataFile.find(params[:file_ids])
      fields = params[:file_fields]
      @merge_file.merge_name = params[:merge_name]+'_'+@merge_file._id
      @end_file = MergeFile.start_merge_files(files, fields, @merge_file.merge_name)
      if @merge_file.save
        flash[:notice] = "Your files has been successfully merged."
      	redirect_to @merge_file
      else
        format.html { redirect_to new_merge_files_path, :notice => "Nao foi possivel criar o Merge" }
      end
  	end

    def destroy
      @merge_file = current_user.merge_files.find(params[:id])
      initial_inputs_id = @merge_file.initial_input_id
      MergeFile.destroy_merged_collection(@merge_file.merge_name)
      @merge_file.destroy
      flash[:notice] = "Dado foi removido"
      redirect_to initial_input_path(initial_inputs_id)
    end

  	def start
      merge_file = MergeFile.find(params[:id])
      files = DataFile.find(merge_file.file_ids)
      fields = merge_file.file_fields
      name = params[:merge_name]
  		@end_file = MergeFile.start_merge_files(files, fields, name)
  	end

    def show
      @merged_file = MergeFile.find(params[:id])
      merge_name = @merged_file.merge_name
      @merged_files = @merged_file.to_xls(merge_name)
      respond_to do |format|
        format.html
        format.csv { send_data @merged_file.to_csv(merge_name) }
        format.xls { render :xls => @merged_files }
      end
    end
end
