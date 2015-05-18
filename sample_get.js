var https = require('https');
var access_token;
var prompt = require('prompt');

// Use prompt to get venmo access token
prompt.start();
prompt.message = "";
prompt.delimiter = "";
console.log("Please enter your Venmo access token below:");
console.log();
prompt.get(['access_token'], function (err, results) {
  // print error if error
  if (err) {
    return accessTokenErr(err);
  }
  access_token = results.access_token;
  usage(0);
  run();
});

function usage(code) {
  switch(code) {
    case 0:
      console.log();
      console.log("Now that you've entered your access token, use the commands" +
        " below to execute venmo commands from the command line");
      console.log();
      console.log("about_me     - Get info about the user associated with this access token");
      console.log("friend_list  - Get a list of the user's friend");
      console.log("quit         - Quit the program");
      console.log();
      break;
    case 1:
      console.log();
      console.log("Use the commands below to execute venmo commands from the" +
        " command line");
      console.log("about_me     - Get info about the user associated with this access token");
      console.log("friend_list  - Get a list of the user's friend");
      console.log("quit         - Quit the program");
      console.log();
      break;
  }
}

function run() {
  process.stdin.resume();
  process.stdin.setEncoding('utf8');
  var util = require('util');

  prompt.get(['command'], function (err, results) {
  // print error if error
    if (err) {
      return accessTokenErr(err);
    }

    switch(results.command) {
      case 'quit':
        done();
      case 'about_me':
        console.log("Executing: about_me");
        getUserInfo();
        break;
      case 'friend_list':
        console.log("Executing: friend_list");
        run();
        break;
      default:
        console.log();
        console.log("Did not recognize the command, please enter in a correct command");
        usage(1);
        run();
        break;
    }
  });

  function done() {
    console.log();
    console.log("Exiting the program, goodbye!");
    console.log();
    process.exit();
  }
}

function accessTokenErr(err) {
  console.log(err);
  return 1;
}

// Get info about a user
function getUserInfo() {
  var options = {
    host: "api.venmo.com",
    path: "/v1/me?access_token=" + access_token
  };

  console.log(options);

  callback = function(response) {
    var str = '';

    response.on('data', function (chunk) {
      str += chunk;
      console.log("Recieved: " + chunk);
    });

    response.on('end', function() {
      console.log(str);
      console.log();
    });
  }

  https.request(options,callback).end();
}

