# encoding: UTF-8
class CsvFileCollection
	include Mongoid::Document

	def self.import_to_mongo(data_file_id, file_path)
		# debugger
		CSV.foreach(file_path.tempfile, headers: true) do |row|
			# row.to_hash
			CsvFileCollection.with(collection: 'bio_'+data_file_id).create! row.to_hash
		end
	end

	def self.open_spreadsheet(file)
		case File.extname(file.original_filename)
		when '.csv' then Roo::Csv.new(file.tempfile.path, nil, :ignore)
		when '.xls' then Roo::Excel.new(file.tempfile.path, nil, :ignore)
		when '.xlsx' then Roo::Excelx.new(file.tempfile.path, nil, :ignore)
		else raise "Unknown file type: #{file.original_filename}"
		end
	end	

	def self.import_to_mongo_xls(data_file_id, file_path)
		spreadsheet = open_spreadsheet(file_path)
		header = spreadsheet.row(1)
		(2..spreadsheet.last_row).each do |i|
			row = Hash[[header, spreadsheet.row(i)].transpose]
			CsvFileCollection.with(collection: 'bio_'+data_file_id).create! row.to_hash
		end
	end

	def self.destroy_mongo_import(data_file_id)
		session = Mongoid.default_session
		col = 'bio_'+data_file_id
		collection_to_drop = session[col]
		collection_to_drop.drop
	end

end
