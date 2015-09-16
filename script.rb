require 'tesseract-ocr'

FILE_NAME = ARGV[0]

e = Tesseract::Engine.new {|e|
  e.language  = :eng
  e.blacklist = '|'
}

puts e.text_for(FILE_NAME).strip # => 'ABC'