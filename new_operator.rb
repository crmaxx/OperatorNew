#!/usr/bin/env ruby

require 'erb'
require 'csv'

csv_file = File.expand_path('../smsjoin.csv', __FILE__)
erb_file = File.expand_path('../add_service_number.sql.erb', __FILE__)
sql_file = File.expand_path('../add_service_numbers.sql', __FILE__)

def save(file, data)
  File.open(file, 'a') do |f|
    f.puts data
    f.puts "\n"
  end
end

save(sql_file, 'spool add_service_number.log')

CSV.foreach(csv_file, col_sep: ';') do |row|
  @name, @description, @snumber, @in_sms_price, @operator_share, @module_name = row
  save(sql_file, ERB.new(File.read(erb_file)).result(binding))
end

save(sql_file, 'spool off')
