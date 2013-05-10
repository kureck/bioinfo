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
end
