#!/usr/bin/ruby
$LOAD_PATH << '.'

require "highline/import"
require 'net/https'
require 'json'

require 'Levenshtein.rb'

# Global Variables
#   id => user_id associated with the entered access token
#   friend_arr => array of friend json variables
#   id_map

# Print usage commands
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

# Get user_id associated with the input access_token
def get_user_id
  $id = JSON.parse(Net::HTTP.get(URI("https://api.venmo.com/v1/me?access_token=#{$access_token}")))["data"]["user"]["id"]
end

# Get list of the user's friends
def get_friend_list
  num_friends = JSON.parse(Net::HTTP.get(URI("https://api.venmo.com/v1/me?access_token=#{$access_token}")))["data"]["user"]["friends_count"]
  $friend_arr = JSON.parse(Net::HTTP.get(URI("https://api.venmo.com/v1/users/#{$id}/friends?access_token=#{$access_token}&limit=#{num_friends}")))["data"]
  $id_map = {}
  $friend_arr.each do |friend|
    $id_map.store("#{friend["display_name"]}", "#{friend["id"]}")
  end
end

# Find the id corresponding to a given username
def find_friend(friend)
  id = $id_map[friend]
  while id.nil?
    # Levenstein distance suggestions
    suggestions = find_closest(friend)
    # Suggesting different names
    puts "Couldn't find the user you're looking for here are some people with similar names"
    puts ""
    suggestions.each do |k, v|
      puts k
    end
    puts ""
    # Getting new suggestion
    friend = ask "Who did you want to charge? "
    id = $id_map[friend]
  end
  return friend
end

# Find the closest
def find_closest(name)
  dist_map = {}
  min_levenshtein = (2**(0.size * 8 -2) -1)

  # Calc levenshtein dist for all words
  $id_map.each do |full_name, id|
    dist = Levenshtein.distance(name, full_name)
    if dist < min_levenshtein
      min_levenshtein = dist
    end
    dist_map.store("#{full_name}", dist)
  end

  # Pick names w/ smallest levenshtein distance and
  dist_map.each do |k, v|
    if v > min_levenshtein && !(k.include? name)
      dist_map.delete(k)
    end
  end

  return dist_map
end

# Display a JSON object of the user's information
def about_me
  puts ""
  puts JSON.pretty_generate(JSON.parse(Net::HTTP.get(URI("https://api.venmo.com/v1/me?access_token=#{$access_token}"))))
  puts ""
end

# Display a JSON object of the user's friends
def my_friends
  puts ""
  puts JSON.pretty_generate(JSON.parse(Net::HTTP.get(URI("https://api.venmo.com/v1/users/#{$id}/friends?access_token=#{$access_token}"))))
  puts ""
end

# Charge a user an amount with an associated note
def charge(amount, id, note)
  # Dealing with positive payments
  if amount.to_i > 0
    amount = (-amount.to_i).to_s
  end
  # Processing payment
  uri = URI("https://api.venmo.com/v1/payments")
  params = {'access_token' => $access_token, 'user_id' => id, 'note' => note, 'amount' => amount}
  puts JSON.pretty_generate(params)
  response = Net::HTTP.post_form(uri,params)
  puts JSON.pretty_generate(JSON.parse(response.body))
end

# Pay a user an amount with an associated note
def pay(amount, id, note)
  # Dealing with negative payments
  if amount.to_i < 0
    amount = (-amount.to_i).to_s
  end
  # Processing payment
  uri = URI("https://api.venmo.com/v1/payments")
  params = {'access_token' => $access_token, 'user_id' => id, 'note' => note, 'amount' => amount}
  puts JSON.pretty_generate(params)
  response = Net::HTTP.post_form(uri,params)
  puts JSON.pretty_generate(JSON.parse(response.body))
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

  # Exit the program
  if input == "quit"
    break

  # Display JSON of user attributes
  elsif input == "about_me"
    about_me

  # Display JSON of user's friends
  elsif input == "my_friends"
    my_friends

  # Charge a friend
  elsif input == "charge"
    num_friends = ask "Do you want to charge one person or a group? (one/many) "
    if num_friends == "one"
      puts ""

      # Dealing with imperfect input
      friend = ask "Who do you want to charge? "
      friend = find_friend(friend)
      id = $id_map[friend]

      # Charging the friend
      amount = ask "How much do you want to charge " + friend + "? "
      note = ask "What would you like your charge to say? "
      charge(amount, id, note)

    elsif num_friends == "many"
      puts "Please input the group of people you'd like to charge as a comma-delimited list"
      puts "Example: John Smith, Tommy Sawyer, Mike Browne"
      puts ""
      friend_list = ask "Who do you want to charge? "
      friend_list = friend_list.split(', ')
      charge_list = {}

      # Getting charge specs for each friend
      friend_list.each do |friend|
        friend = find_friend(friend)
        id = $id_map[friend]
        amount = ask "How much do you want to charge " + friend + "? "
        note = ask "What would you like your charge to say? "
        charge_list.store(note, [id, amount])
      end

      # Executing each charge
      charge_list.each do |note, arg|
        charge(arg[1], arg[0], note)
      end
    end

  # Pay a friend
  elsif input == "pay"
    num_friends = ask "Do you want to pay one person or a group? (one/many) "
    if num_friends == "one"
      puts ""

      # Dealing with imperfect input
      friend = ask "Who do you want to pay? "
      friend = find_friend(friend)
      id = $id_map[friend]

      # Charging the friend
      amount = ask "How much do you want to pay " + friend + "? "
      note = ask "What would you like your payment to say? "
      charge(amount, id, note)

    elsif num_friends == "many"
      puts "Please input the group of people you'd like to pay as a comma-delimited list"
      puts "Example: John Smith, Tommy Sawyer, Mike Browne"
      puts ""
      friend_list = ask "Who do you want to pay? "
      friend_list = friend_list.split(', ')
      charge_list = {}

      # Getting charge specs for each friend
      friend_list.each do |friend|
        friend = find_friend(friend)
        id = $id_map[friend]
        amount = ask "How much do you want to pay " + friend + "? "
        note = ask "What would you like your payment to say? "
        charge_list.store(note, [id, amount])
      end

      # Executing each charge
      charge_list.each do |note, arg|
        charge(arg[1], arg[0], note)
      end

  # Display commands
  elsif input == "help"
    usage(1)

  # Dealing with unknown inputs
  else
    # puts "echo: " + input
  end
end
