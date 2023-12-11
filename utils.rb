require 'httparty'
require_relative 'variables'

def query(api_endpoint)
  response = HTTParty.get(api_endpoint, headers: { 'Accept' => 'application/json' })
  return response
end

def get_single_joke(api_endpoint)
  response = query(api_endpoint)
  
  if response.success? && response['setup'] && response['delivery']
    setup = response['setup']
    delivery = response['delivery']
    return "#{setup} #{delivery}"
  elsif response.success? && response['joke']
    joke = response['joke']
    return joke
  else
    puts "API request failed with response code: #{response.code}"
    puts "Response body: #{response.body}"
    return "Sorry, an unexpected error occurred while fetching a joke."
  end
end
