require "highline/import"
require 'net/https'
require 'json'

# Get access token for the program
puts ""
$access_token = ask "Please input your Venmo access token: "

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

def about_me
  puts ""
  puts Net::HTTP.get(URI('https://api.venmo.com/v1/me?access_token=' + $access_token))
end

def my_friends
end


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
    # puts "Executing my_friends"
  else
    # puts "echo: " + input
  end
  usage(1)
end
