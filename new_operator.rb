#!/usr/bin/env ruby

require 'erb'
require 'csv'
require 'open-uri'
require 'nokogiri'

csv_file = File.expand_path('../platinote-countries.csv', __FILE__)
erb_file = File.expand_path('../add_service_number.sql.erb', __FILE__)
sql_file = File.expand_path('../add_service_numbers.sql', __FILE__)

def save(file, data)
  File.open(file, 'a') do |f|
    f.puts data
    f.puts "\n"
  end
end

def get_country_code(country)
  Nokogiri::HTML(open("http://countrycode.org/#{country}")).css('#main_table_blue_2 tr th h1').text.strip.split(' ').last
end

save(sql_file, 'spool add_service_number.log')

CSV.foreach(csv_file, col_sep: ';') do |row|
  @country, @name, @description, @module_name, @snumber, @in_sms_price, @operator_share, @basic, @profi, @premium = row
  @country_code = get_country_code(@country)
  save(sql_file, ERB.new(File.read(erb_file)).result(binding))
end

save(sql_file, 'spool off')
