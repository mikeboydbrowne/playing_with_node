require "highline/import"
require 'net/https'
require 'json'

# Print commands you
def usage (code)
  if code == 0
    puts ""
    puts "Thanks for putting in your access token!"
  end
  puts ""
  puts "Use the commands below to execute Venmo from your terminal"
  puts "  about_me    - get a JSON representation of information about the user"
  puts "  my_friends  - get a JSON list of this user's friends"
  puts "  charge      - charge a friend"
  puts "  pay         - pay a friend"
  puts "  quit        - exit script"
  puts "  help        - show usage"
  puts ""
end

def get_user_id
  $id = JSON.parse(Net::HTTP.get(URI('https://api.venmo.com/v1/me?access_token=' + $access_token)))["data"]["user"]["id"]
end

def about_me
  puts ""
  puts JSON.pretty_generate(JSON.parse(Net::HTTP.get(URI('https://api.venmo.com/v1/me?access_token=' + $access_token))))
  puts ""
end

def my_friends
  puts ""
  puts JSON.pretty_generate(JSON.parse(Net::HTTP.get(URI('https://api.venmo.com/v1/users/' + $id + '/friends?access_token=' + $access_token))))
  puts ""
end

def charge(amount, friend)
  puts amount
  puts friend
end

def pay(amount, friend)
  puts amount
  puts friend
end

# Get access token for the program
puts ""
$access_token = ask "Please input your Venmo access token: "
get_user_id

# Initial usage message
usage(0)
# Read input/execute commands from the user
while true do
  input = ask "> "
  # exit the program
  if input == "quit"
    break
  # Get JSON of user attributes
  elsif input == "about_me"
    about_me
  # Get JSON of user's friends
  elsif input == "my_friends"
    my_friends
  # Charge a friend
  elsif input == "charge"
    friend = ask "Who do you want to charge?"
    amount = ask "How much do you want to charge " + friend + "?"
    charge(amount, friend)
  # Pay a friend
  elsif input == "pay"
    friend = ask "Who do you want to pay?"
    amount = ask "How much do you want to pay " + friend + "?"
    charge(amount, friend)
  # Display commands
  elsif input == "help"
    usage(1)
  else
    # puts "echo: " + input
  end
  # usage(1)
end
