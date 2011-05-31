# JSHINT Service

A super simple node server for accepting js as a POST body and running it through [jshint](http://jshint.com).

## Setup

The server can be setup with the chef cookbooks, though they are very simple. One important note is that the `npm install express` is failing inexplicably.

## Pre Commit Hook

Also included is a relatively simple pre-commit git hook that prevents commits on `console.` , `debugger`, and `alert` statements in your js, and also produces jshint warnings for all js files staged in the index for commit by contacting a deployed version of the server.

## Motivation

Node doesn't install easily and it seems silly to make it a dependency for developers to benefit from jshint checks on their javascript. Thus the server and hook were born.
