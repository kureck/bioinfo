# encoding: UTF-8
class DataFile < ActiveRecord::Base
	attr_accessible :csvfile, :description, :initial_input_id, :title, :header
	belongs_to :initial_input
	mount_uploader :csvfile, CsvfileUploader

	def upload_file_name
		File.basename(self.csvfile.to_s)
	end

	def self.header(file_path)
		header = CSV.parse_line(file_path.tempfile)
		header.map{|a| a.force_encoding('UTF-8')}
		header.to_s
	end

	def header_to_array
		self.header.gsub(/(\[\"|\"\])/, '').split('", "')
	end

	def self.header_to_array(header)
		header.gsub(/(\[\"|\"\])/, '').split('", "')
	end

end
