#!/bin/bash

# Don't allow console.log() or alert statements to be committed.
# adapted from jlindley's console check https://gist.github.com/673376
#
# add to or replace .git/hooks/pre-commit with the following to use
#
grep_bad=$(grep -inR "console\.\|alert(" js/*.js)
count=$(echo -e "$grep_bad" | grep "[^\s]" | wc -l | awk '{print $1}')

if [[ "$count" -ge 1 ]]; then
  echo "[warning] aborting commit"
  echo "[warning] $count config.log/alert found:"
  echo -e "$grep_bad"
  exit 1
fi

# Verify that the shell is able to connect to the internet
# so that the jshint service can be called
ping -c 1 -w 1 google.com &> /dev/null
if [[ $? -gt 0 ]]; then
  echo "[warning] internet connection appears to be down, skipping jshint"
  exit 0
fi

#TODO point at actual service
JSHINT_SERVICE=http://33.33.33.10:3000/

curl -v -H "Content-Type: text/plain" -X POST -d 'foo = "bar1";' '$JSHINT_SERVICE'

	# call jshint service
fi