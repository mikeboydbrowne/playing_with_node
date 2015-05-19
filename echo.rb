require "highline/import"

# Get access token for the program
access_token = ask "Please input your Venmo access token: "

# Usage function to
def usage (code)
  if code == 0
    puts "Thanks for putting in your access_token, now use this program to execute"
    " Venmo commands from your terminal"
  end
end

while true do
  usage(0)
  input = ask "> "
  if input == "quit"
    break
  else
    puts "echo: " + input
  end
end
