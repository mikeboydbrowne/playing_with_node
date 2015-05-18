// basic
var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end(reg_form.toHTML());
}).listen(1337, '127.0.0.1');
console.log('Server running at http://127.0.0.1:1337/');


// form
var forms = require('forms');
var fields = forms.fields;
var validators = forms.validators;

var reg_form = forms.create({
    username: fields.string({ required: true }),
    password: fields.password({ required: validators.required('You definitely want a password') }),
    confirm:  fields.password({
        required: validators.required('don\'t you know your own password?'),
        validators: [validators.matchField('password')]
    }),
    email: fields.email()
});
