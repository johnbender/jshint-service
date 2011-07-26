# JSHINT Service

A super simple node server for accepting js as a POST body and running it through [jshint](http://jshint.com).

## Motivation

Node doesn't install easily and it seems silly to make it a dependency for developers who want to benefit from jshint checks on their javascript in their commit hooks. Thus the server and hook were born.

## Setup

The service is designed to be deployed to [heroku](http://devcenter.heroku.com/articles/quickstart), which is the preferred method. The Chef cookbooks have been retained for those who prefer to deploy it elsewhere.

    $ git clone git@github.com:johnbender/jshint-service.git
    $ cd jshint-service
    $ heroku create
    $ git push heroku master

For heroku installation and information please see the [documentation](http://devcenter.heroku.com/).

## Pre Commit Hook

Included is a relatively simple pre-commit git hook that prevents commits on `console.` , `debugger`, and `alert` statements in your js, and also produces jshint warnings for all js files staged in the index for commit by contacting a deployed version of the server.

There are three ways to configure the hook: the service uri, the config options file, and the globals file.

The service uri should be self explanatory but I've deployed a version of the service to heroku at http://jshint-service.herokuapp.com/ if you don't want to host one yourslef. *Please use responsibly*

The config options file should be valid json with the defaults as follows:

```javascript

		config = {
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

```

The globals represent pre-defined global options that JSHINT should ignore when linting your javascript (ie jQuery).

Enjoy!
