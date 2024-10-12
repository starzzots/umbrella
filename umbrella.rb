require "http"
require "json"

puts "Where are you located?"

#user_location = gets.chomp
user_location = "Chicago"
puts "Checking weather at #{user_location}..."

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

puts "Your coordinates are Latitude:#{lat}, Longitude:#{lng}"

weather_url="https://api.pirateweather.net/forecast/#{ENV.fetch("PIRATE_WEATHER_API_KEY")}/#{lat},#{lng}"

weather_resp = HTTP.get(weather_url)
weather_resp_raw = weather_resp.to_s

weather_resp_parsed = JSON.parse(weather_resp_raw)

current_weather = weather_resp_parsed.fetch("currently")

temp = current_weather.fetch("temperature")

puts "It is currently #{temp}°F." #hold alt + 0176 = ° 


