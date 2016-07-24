# Introducing the addressbook_txt gem

The addressbook_txt gem makes it easier to manage your addresses in a free-form format in a plain-text file. The only requirements are that the file has has a underlined heading and each entry is defined by a hash symbol (#) on the 1st column of the current row e.g.

<pre>
addressbook.txt
===============

# Timberland

1, Forest View,
Oaklandville,
Canada

# Mrs Burton

11 Church Way
Granton,
Skegness
SK45 24W

0183 445 6381
</pre>

## Archiving

Archiving is performed automatically whenever the file is saved from the AddressbookTxt object e.g.

    require 'addressbook_txt'

    ab = AddressbookTxt.new path: '/tmp'
    ab.save

The above example imports the *addressbook.txt* file to a Dynarex file and archives the file to the directory */tmp/archive/addressbook-2016.xml*

## Searching for an address

    require 'addressbook_txt'

    ab = AddressbookTxt.new path: '/tmp'
    ab.search 'burton'

The above example would search the current address book using the keyword 'burton'. If it doesn't find a match it will then search the archive.

Notes:

* The entries are specifically stored in a SectionX format which allows a single entry to occupy many lines.
* A SectionX entry much start with a Markdown heading 1 identifier e.g. *# Some heading*.

## Resources

* addressbook_txt https://rubygems.org/gems/addressbook_txt

## See also 

* Introducing the contacts_txt gem http://www.jamesrobertson.eu/snippets/2015/dec/13/introducing-the-contacts_txt-gem.html

addressbook addressbook_txt gem gtd addresses
