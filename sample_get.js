var https = require('https');
var arguments = process.argv.slice(2);

var options = {
  host: "api.venmo.com",
  path: "/v1/me?access_token=" + arguments[0]
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
  });
}

https.request(options,callback).end();
