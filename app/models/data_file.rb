class DataFile < ActiveRecord::Base
  attr_accessible :csvfile, :description, :initial_input_id, :title
  belongs_to :initial_input
  mount_uploader :csvfile, CsvfileUploader
end
