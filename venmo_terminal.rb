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
  $id = JSON.parse(Net::HTTP.get(URI("https://api.venmo.com/v1/me?access_token=#{$access_token}")))["data"]["user"]["id"]
end

def get_friend_list
end

def about_me
  puts ""
  puts JSON.pretty_generate(JSON.parse(Net::HTTP.get(URI("https://api.venmo.com/v1/me?access_token=#{$access_token}"))))
  puts ""
end

def my_friends
  puts ""
  puts JSON.pretty_generate(JSON.parse(Net::HTTP.get(URI("https://api.venmo.com/v1/users/#{$id}/friends?access_token=#{$access_token}"))))
  puts ""
end

def find_friend(name)
  return id
end

def charge(amount, id, note)
  uri = URI("https://api.venmo.com/v1/payments")
  # friendid = "1621210827849728258"
  # note = "Test Payment"
  # amount = -1
  params = {'access_token' => $access_token, 'user_id' => id, 'note' => note, 'amount' => amount}
  puts JSON.pretty_generate(JSON.parse(Net::HTTP.post_form(uri,params)))
end

def pay(amount, friend, note)
  puts amount
  puts friend
end

# Initialize program with access token, user_id, and friend => user_id mappings
puts ""
$access_token = ask "Please input your Venmo access token: "
get_user_id       # get user_id associated with this access_token
get_friend_list   # get friend => user_id mappings

# Input loop
usage(0)
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
    id = find_friend(friend)
    amount = ask "How much do you want to charge " + friend + "?"
    note = ask "What would you like your charge to say?"
    charge(amount, friend, note)

  # Pay a friend
  elsif input == "pay"
    friend = ask "Who do you want to pay?"
    id = find_friend(friend)
    amount = ask "How much do you want to pay " + friend + "?"
    note = ask "What would you like your payment to say?"
    pay(amount, friend, note)

  # Display commands
  elsif input == "help"
    usage(1)

  # Dealing with unknown inputs
  else
    # puts "echo: " + input
  end
end
