class ProcessData

	attr_accessor :input_file, :output_filename

	def initialize(input_file, output_filename)
		# if tab delimited text file created from Excel, we need to enable the .encode option. It defaults to UTF-8
		@input_file = File.read(input_file)#.encode!('iso-8859-1', 'iso-8859-1', :invalid => :replace)
		@output_filename = output_filename
		@output_file = File.open(output_filename, "w")
	end

	# What this will do, it takes the mailing name column in a TXT file and finds the "first name" and adds it into a column
	# at the end of the file. Spits out a tab delimited text file
	def create_first_name_from_mailing_name
		# remove any salutations first
		bad_char_array = ["Miss", "Ms.", "Mr.", "Mrs.", "Dr.", "MRS"]
		rows = @input_file.split("\r")
		# open the output file and add the "write" param
		new_header = rows.first + "\tfirst_name\n" 
		@output_file << new_header
		rows.each do |line|
			# skip header row
			next if rows.index(line) == 0
			tabs = line.split("\t")

			mailing_name = tabs[1]
			# remove any salutation and unnecessary quotes and remove spaces
			bad_char_array.each{|b| mailing_name = mailing_name.gsub("\"", "").gsub(b, "").strip}
			# find first name in mailing name array by finding first word in string
			first_name = mailing_name.split(" ").first
			# put first name at end of row array
			tabs << first_name

			# put file back together
			new_row = tabs.join("\t")+"\n"
			# inserting new rows into new output file
			@output_file << new_row
		end
		@output_file.close
		puts "The file /" + @output_filename + " is ready"
	end

end