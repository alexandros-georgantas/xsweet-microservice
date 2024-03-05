#!/usr/bin/ruby
#For container application's docker files should have commands to install `ruby` and `mathtype gem`
require 'mathtype'
puts "Converting MathType binaries to MREF XML..."
texInToHtml=ARGV[3]
mtef2tex=ARGV[2]

saxonjarpath = ARGV[1]

outXMLDir=ARGV[0] + "/mtefxml/"
outTEXDir=ARGV[0] + "/tex/"

# puts "Output Saxon JAR path: "+ saxonjarpath

# puts "Output XML directory: " + outXMLDir

if not (File.directory?(outXMLDir))
    Dir.mkdir(outXMLDir)
end

# puts "Output TEX directory: " + outTEXDir

if not (File.directory?(outTEXDir))
    Dir.mkdir(outTEXDir)
end

# puts "Starting Ruby script..."

#This will slow down the xsweet conversion pipeline depending on the number of wmf files.

#Here each wmf files in media folder is converted to mtef xml and saved in new `mtefxml` folder
Dir.foreach(ARGV[0]) do |filename|
	begin
    if filename.end_with?(".wmf")
        binaryFile = "#{ARGV[0]}/#{filename}"         
        texFile = "#{outXMLDir}/#{filename.sub! '.wmf' , ''}"
        xml = Mathtype::Converter.new(binaryFile).to_xml
        File.open(texFile, 'w') { |file| file.write(xml) }        
    end
	rescue Exception => e
		puts "Error: #{e}"
	end
end

#Instead of parsing each file in a loop saxon has feature to convert all the xml files in in mtefxml in folder to latex files
#Folder converion makes it efficient eg $java -jar saxon.jar -s:source_folder -o:destination_folder.
saxonHE = "java -jar #{saxonjarpath}"
%x`#{saxonHE} -xsl:#{mtef2tex} -s:#{outXMLDir} -o:#{outTEXDir}`

# puts "Ruby script done!" 

