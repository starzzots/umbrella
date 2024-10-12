require "http"
require "json"

puts "Where are you located?"

user_location = gets.chomp
#user_location = "Chicago"
pp user_location

maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{ENV.fetch("GMAPS_KEY")}"

resp = HTTP.get(maps_url)

raw_response = resp.to_s

parsed_response = JSON.parse(raw_response)

results = parsed_response.fetch("results")

first_result = results[0]

gemoetry = first_result.fetch("geometry")

loc = gemoetry.fetch("location")

lat = loc.fetch("lat")
lng = loc.fetch("lng")

pp lat
pp lng
