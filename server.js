require.paths.unshift(".");

var express = require("express"),
		app = express.createServer(),
		jshint = require("jshint/jshint"),
		config = {
			"predef": [
				"jasmine",
				"spyOn",
				"it",
				"describe",
				"expect"
			],

			"node" : true,
			"es5" : true,
			"browser" : true,

			"boss" : false,
			"curly": false,
			"debug": false,
			"devel": false,
			"eqeqeq": true,
			"evil": false,
			"forin": false,
			"immed": true,
			"laxbreak": false,
			"newcap": true,
			"noarg": true,
			"noempty": false,
			"nonew": false,
			"nomen": false,
			"onevar": true,
			"plusplus": false,
			"regexp": false,
			"undef": true,
			"sub": true,
			"strict": false,
			"white": false
		};

app.post('/', function(req, res){
	var body = '';

	// gather body data
  req.on('data', function(chunk) {
    body += chunk.toString();
  });

	// once the body data is gathered run it through hint
	req.on('end', function(){
		var result = "";
		jshint.JSHINT(body, config);
		jshint.JSHINT.errors.forEach(function(error){
			console.log(error);
			result += "line " + error.line + ": " + error['reason'] + " \n";
		});

		res.send(result);
	});
});

app.listen(3000);