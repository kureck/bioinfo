class InitialInput
	include Mongoid::Document
	include Mongoid::Timestamps

	field :title, 		:type => String, 	:default => ''
	field :description, :type => String,	:default => ''

	attr_accessible :description, :title, :user_id
	belongs_to :user

	has_many :data_files, :dependent => :destroy
	has_many :merge_files, :dependent => :destroy
end
