#!/usr/bin/env ruby

# file: addressbook_txt.rb

require 'date'
require 'dynarex'
require 'fileutils'



# The AddressbookTxt gem can:
#
#  [x] create a new addressbook.txt file
#  [x] read an existing addressbook.txt file
#  [x] search each entry using a keyword
#  [ ] archive address entries on an annual basis
#  [ ] search the archive using a keyword



class AddressbookTxt
  
  attr_reader :to_s

  def initialize(filename='addressbook.txt', path: '.')
    
    @filename, @path = filename, path
    
    fpath = File.join(path, filename)
    
    if File.exists?(fpath) then

      @dx = import_to_dx(File.read(fpath))    
          
    else
      @dx = new_dx    
    end
  end

  def dx()
    @dx
  end
  
  def save(filename=@filename)

    s = File.basename(filename) + "\n" + dx_to_s(@dx).lines[1..-1].join
    File.write File.join(@path, filename), s
    @dx.save File.join(@path, filename.sub(/\.txt$/,'.xml'))
        
  end
  
  def search(keyword)
    dx.all.select {|r| r.x =~ /#{keyword}/i}
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