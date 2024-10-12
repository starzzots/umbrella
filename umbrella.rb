require "http"
require "json"

puts "Where are you located?"

user_location = gets.chomp
#user_location = "Chicago"
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

hourly_weather = weather_resp_parsed.fetch("hourly")

hourly_data = hourly_weather.fetch("data")[1..12]
any_precipitation = false
precip_prob_threshold = 0.10
hourly_data.each do |hour_hash|

  precip_prob = hour_hash.fetch("precipProbability")

  if precip_prob > precip_prob_threshold
    any_precipitation = true

    precip_time = Time.at(hour_hash.fetch("time"))

    seconds_from_now = precip_time - Time.now

    hours_from_now = seconds_from_now / 60 / 60

    puts "In #{hours_from_now.round} hours, there is a #{(precip_prob * 100).round}% chance of precipitation."
  end
end

if any_precipitation == true
  puts "You might want to take an umbrella!"
else
  puts "You probably won't need an umbrella."
end
