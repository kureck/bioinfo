class DataFile < ActiveRecord::Base
  attr_accessible :csvfile, :description, :initial_data_id, :title
  belongs_to :initial_data
  mount_uploader :csvfile, CsvfileUploader
end
