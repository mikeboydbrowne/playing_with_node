require "highline/import"
require 'net/https'
require 'json'

# Usage function to
def usage (code)
  if code == 0
    puts ""
    puts "Thanks for putting in your access token!"
    puts ""
  end
  puts ""
  puts "Use the commands below to execute Venmo from your terminal"
  puts "about_me    - get a JSON representation of information about the user"
  puts "my_friends  - get a JSON list of this user's friends"
  puts ""
end

def get_user_info

  $id = JSON.parse(Net::HTTP.get(URI('https://api.venmo.com/v1/me?access_token=' + $access_token)))["data"]["user"]["id"]
  puts $id
end

def about_me
  puts ""
  puts JSON.pretty_generate(JSON.parse(Net::HTTP.get(URI('https://api.venmo.com/v1/me?access_token=' + $access_token))))
end

def my_friends
  puts ""
  puts JSON.pretty_generate(JSON.parse(Net::HTTP.get(URI('https://api.venmo.com/v1/users/' + $id + '/friends?access_token=' + $access_token))))
end


# Get access token for the program
puts ""
$access_token = ask "Please input your Venmo access token: "
get_user_info


# Initial usage message
usage(0)
# Read input/execute commands from the user
while true do
  input = ask "> "
  if input == "quit"
    break
  elsif input == "about_me"
    about_me
    # puts "Executing about_me"
  elsif input == "my_friends"
    my_friends
  else
    # puts "echo: " + input
  end
  usage(1)
end
