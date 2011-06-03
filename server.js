require.paths.unshift("/usr/local/jshint-service");
require.paths.unshift("/usr/lib/node_modules");

var express = require("express"),
		app = express.createServer(),
		jshint = require("jshint/jshint"),
		config = {
			"predef": [
				"jQuery"
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

app.configure(function () {
    app.use(require('connect-form')({keepExtensions: true}));
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
    app.use(express.bodyParser());
});

app.get('/', function(req, res){
	res.send("<h1 style='text-align: center; font-size: 120px;'>ZOMG JSHINT</h1>");
});

app.post('/', function (req, res) {
    if (! req.form) {
        throw new TypeError("form data required");
    }
    return req.form.complete(function (err, fields, files) {
		var result = "";
		var globals = {};
		
		try {
			config = (fields.config)?JSON.parse(fields.config):config;
			globals = (fields.globals)?JSON.parse(fields.globals):globals;
		} catch (e) {
			console.error("Error while parsing options string, it should be valid JSON:",e);
		}
		var passed = false;
		jshint.JSHINT(fields.source, config, globals);
		jshint.JSHINT.errors.forEach(function(error){
			if (error) {
				console.log(error);			
				result += "line " + error.line + ": " + error.reason + " \n";
			}
		});

		res.send(result, {'Content-Type': 'text/plain'});
    });
});

app.listen(3000);