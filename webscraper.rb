require 'mechanize'
require 'WriteExcel'

mechanize = Mechanize.new
page = mechanize.get('https://www.nhs.uk/service-search/GP/London/MapView/4/-0.085/51.511/4/13136?distance=25&ResultsOnPageValue=10&isNational=0&totalItems=1967&currentPage=1')
workbook = WriteExcel.new('NHS Clinics London.xls')
worksheet = workbook.add_worksheet
b = 0
while page.at('#btn_searchresults_next a') do
resultsarray = page.css('.mapview-details-content li')
begin
resultsarray.each do |f|
title = f.at('.mapview-details-header').text.strip
location = f.at('.fcaddress').text.strip
link = page.link_with(text: title)
subpage = mechanize.click(link)
website = subpage.at('.panel-content strong').text.strip
if f.at('.fctel')
tele = f.at('.fctel').text.strip
end
locationarray = location.split("\n")
postcode = locationarray.last
locationarray.delete(postcode)
locationstring = ""
j = 1 
locationarray.each do |i|
unless j <= 1
locationstring += ", " + i.strip
else
locationstring += i.strip
end
j += 1
end
puts website
puts tele
puts title
puts locationstring
puts postcode.strip
worksheet.write(b,1, title)
worksheet.write(b,2, locationstring)
worksheet.write(b,3, postcode.strip)
worksheet.write(b,4, tele)
worksheet.write(b,5, website)
b += 1
puts b
end

rescue NoMethodError
puts "There was an error"

end
link = page.link_with(text: "Next")
sleep(1.5)
page = mechanize.click(link)
end
workbook.close