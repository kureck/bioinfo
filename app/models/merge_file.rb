class MergeFile
	include Mongoid::Document
	include Mongoid::Timestamps

	field :file_ids, type: Array
	field :file_fields, type: Array
	attr_accessible :file_ids, :file_fields, :user_id, :merge_name, :initial_input_id
	belongs_to :user
	belongs_to :initial_input

	def self.destroy_merged_collection(merge_name)
		session = Mongoid.default_session
		collection_to_drop = session[merge_name]
		collection_to_drop.drop
	end

	def merged_name
		name = self.merge_name
		name = name.split("_")
		name = name[0..name.length-2].join(' ')
		name
	end

	def self.get_collection(merge_name)
		CsvFileCollection.with(collection: merge_name).each
	end

	def get_column_names(merged_files)
		column_names = []
		merged_files[0].value.each do |key, value|
			column_names.push(key)
		end
		column_names
	end

	def get_merged_files_collections(merge_name)
		enumerated_merged_file = CsvFileCollection.with(collection: merge_name).each
		merged_files = []
		enumerated_merged_file.each do |e|
			merged_files.push(e)
		end
		merged_files
	end

	def to_csv(options = {}, merge_name)
		merged_files = get_merged_files_collections(merge_name)
		column_names = get_column_names(merged_files)

		CSV.generate(options) do |csv|
			csv << column_names
			merged_files.each do |merged_file|
				csv << merged_file.value.values_at(*column_names)
			end
		end
	end

	def to_xls(options = {}, merge_name)
		merge = Hash.new
		merged_files = get_merged_files_collections(merge_name)
		column_names = get_column_names(merged_files)
		merge = {merged_files: merged_files, column_names: column_names}
	end

	def self.start_merge_files(files, fields, name)
		name.gsub!(/\s+/, "_")
		maps = Hash.new
		values_map = " "
		fields.each do |field|
			files.each do |f|
				header = f.header_to_array
				header.each do |h|
					values_map = values_map + "#{h}:this.#{h},"
				end
				map = %Q{function() { var values = { #{values_map}}; emit(this.#{field}, values);}}
				values_map = " "
				maps[f.id] = map
			end
		end
		reduce = %Q{function(k, values) {var result = {};values.forEach(function(value) {var field;for (field in value) {if (value.hasOwnProperty(field)) {result[field] = value[field];}}});return result;}}
		maps.each do |key, value|
			CsvFileCollection.with(collection: "bio_"+key).map_reduce(value, reduce).out(reduce: name).emitted
		end
	end
end
