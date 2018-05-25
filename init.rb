require_relative 'import'
require_relative 'config/initializers/rom_initializer'



# Chainable methods example
# include Nokogiri
# CM("foo bar http://github.com/akitaonrails/chainable_methods foo bar")
#     .URI.extract
#     .first
#     .URI.parse
#     .HTTParty.get
#     .HTML.parse
#     .css("H1")
#     .text
#     .unwrap
#
#  INSTEAD OF:
#
# sample_text = "foo bar http://github.com/akitaonrails/chainable_methods foo bar"
# sample_link = URI.extract(sample_text).first
# uri = URI.parse(sample_link)
# response = HTTParty.get(uri)
# doc = Nokogiri::HTML.parse(response)
# title = doc.css("H1").text
#
