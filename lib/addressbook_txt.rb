#!/usr/bin/env ruby

# file: addressbook_txt.rb

require 'date'
require 'dynarex'
require 'fileutils'
require 'rexle-diff'



# The AddressbookTxt gem can:
#
#  [x] create a new addressbook.txt file
#  [x] read an existing addressbook.txt file
#  [x] search each entry using a keyword
#  [x] archive address entries on an annual basis
#  [x] search the archive using a keyword



class AddressbookTxt
  
  attr_reader :to_s, :dx

  def initialize(filename='addressbook.txt', path: File.dirname(filename))        
    
    @filename, @path = File.basename(filename), File.expand_path(path)
    
    fpath = File.join(@path, @filename)
    
    @dx = if File.exists?(fpath) then

      s = File.read(fpath)

      File.extname(@filename) == '.txt' ? import_to_dx(s) :  Dynarex.new(s)

    else
      new_dx()
    end
    
  end
  
  def save(filename=@filename)

    s = File.basename(filename) + "\n" + dx_to_s(@dx).lines[1..-1].join
    File.write File.join(@path, filename), s
    
    xml_file = File.join(@path, filename.sub(/\.txt$/,'.xml'))
    
    if File.exists? xml_file then
      xml_buffer = File.read xml_file
      doc = RexleDiff.new(xml_buffer, @dx.to_xml, fuzzy_match: true).to_doc
      
      File.write xml_file, doc.xml(pretty: true)
    else
      File.write xml_file, @dx.to_xml(pretty: true)
    end
    
    # write the file to the archive
    archive_file = File.join(@path,'archive','addressbook-' + \
                             Date.today.year.to_s + '.xml')
    FileUtils.mkdir_p File.dirname(archive_file)
    FileUtils.cp xml_file, archive_file
        
  end
  
  def search(keyword)

    found = dx.all.select {|r| r.x =~ /#{keyword}/i}

    if found.empty? then
      
      # search the archive
      
      archive_files = File.join(@path,'archive','addressbook-*.xml')

      found = Dir.glob(archive_files).sort.reverse[1..-1].flat_map do |file|
        AddressbookTxt.new(file).search keyword
      end
    end
    
    return found
    
  end
  
  def to_s()
    dx_to_s @dx
  end

  private
  
  def dx_to_s(dx)
   
    title = File.basename(@filename)
    title + "\n" + "=" * title.length + "\n\n%s\n\n" % [dx.to_s(header: false)]

  end  
  
  def import_to_dx(s)

    a = s.lines
    # Remove the heading
    a.shift 2   
    
    # add the sectionx raw document type
    a.unshift '--#'

    dx = new_dx()
    dx.import(a.join)
    
    return dx
  end
  
  def new_dx()
    
    dx = Dynarex.new 'addresses[title]/address(x)'
    dx.title = "Address Book"

    return dx

  end
  
end