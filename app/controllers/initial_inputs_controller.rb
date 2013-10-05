# encoding : utf-8
class InitialInputsController < ApplicationController
	before_filter :authenticate_user!
	def index
		@initial_inputs = current_user.initial_inputs.all
	end

	def new
		@initial_input = InitialInput.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @initial_input }
		end
	end
	
	def create
		@initial_input = current_user.initial_inputs.build(params[:initial_input])
		respond_to do |format|
			if @initial_input.save
				format.html { redirect_to initial_inputs_path, :notice => "Dado inicial criado com sucesso." }
			else
				format.html { redirect_to new_initial_input_path, :notice => "Não foi possivel criar o dado inicial." }
			end
		end
	end
	
	def edit
		@initial_input = current_user.initial_inputs.find(params[:id])
	end

	def update
		@initial_input = current_user.initial_inputs.find(params[:id])

		respond_to do |format|
			if @initial_input.update_attributes(params[:initial_input])
				format.html { redirect_to initial_inputs_path, :notice => "Dado inicial alterado com sucesso." }
			else
				format.html { redirect_to edit_initial_input_path(params[:id]), :notice => "Não foi possível alterar dado inicial." }
			end
		end
	end

	def destroy
		@initial_input = current_user.initial_inputs.find(params[:id])
		@initial_input.destroy
		flash[:notice] = "Dado foi removido"
		redirect_to initial_inputs_path
	end
	
	def show
		@initial_input = current_user.initial_inputs.find(params[:id])
		@merge_files = MergeFile.new
	end
end
