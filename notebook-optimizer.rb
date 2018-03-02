require 'json'
require 'base64'
require 'tempfile'
require 'time'

$optipng_cmd = "optipng -o5 %s"
$imagemagick_cmd = "convert png:%s -format jpg -quality 85 -flatten jpg:%s"

data = JSON.parse(open(ARGV[0]).read)

mode = :optipng
def optipng(data)
	file = Tempfile.new('notebook-optimizer')
	file.write(data)
	file.close

	output = nil
	if system($optipng_cmd % [file.path])
		file.open
		output = file.read
		file.close
	end

	file.unlink
	return output
end

def imagemagick(data)
	file = Tempfile.new('notebook-optimizer')
	file.write(data)
	file.close

	output = nil
	if system($imagemagick_cmd % [file.path, file.path])
		file.open
		output = file.read
		file.close
	end

	file.unlink
	return output
end

# Return blank PNG
def blank()
	Base64.decode64('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABAQMAAAAl21bKAAAAA1BMVEX///+nxBvIAAAACklEQVQI12NgAAAAAgAB4iG8MwAAAABJRU5ErkJggg==')
end


if data.has_key? 'cells'
	data['cells'].each do |cell|
		if cell.has_key? 'outputs'
			cell['outputs'] = cell['outputs'].map do |output|
				type = output['output_type']
				if type == 'stream'
					next nil if output['name'] == 'stderr'
				elsif type == 'display_data'
					unless output['data']['image/png'].nil?
						image = output['data']['image/png'].gsub('\n', "\n")
						png = Base64.decode64(image)

						image = case mode
						when :optipng then optipng(png)
						when :imagemagick then imagemagick(png)
						when :blank then blank()
						else png
						end

						unless image.nil?
							if mode == :imagemagick
								output['data']['image/jpeg'] = Base64.encode64(image)
								output['data'].delete('image/png')
							else
								output['data']['image/png'] = Base64.encode64(image)
							end
						end
					end
				end
				output
			end.compact
		end
	end
end

puts JSON.pretty_generate(data)
