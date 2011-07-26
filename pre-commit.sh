#!/bin/bash
# add to or replace .git/hooks/pre-commit
echo "Running pre-commit"

# helper to print information for users on bad exit status
function on_error {
	if test $? -gt 0  ; then
		echo "[error] $1"
		exit 0
	fi
}

# check connection
ping -c 1 -w 1 google.com > /dev/null 2>&1 || ping -c 1 -t 1 google.com > /dev/null 2>&1
on_error "internet connection appears to be down, skipping jshint"

# check for curl
which curl > /dev/null
on_error "curl is required to contact jshint service, please install"

# NOTE You may use http://jshint-service.herokuapp.com/ if you will do so responsibly
# jshint_uri=http://jshint-service.herokuapp.com/
jshint_uri=change-to-match-your-deployed-server
options_file=change-to-match-your-options-file
globals_file=change-to-match-your-globals-file

cmd_base="curl -s -f -m 2"
if [ -n "$options_file" -a -r $options_file ]; then cmd_base="$cmd_base --form config=<$options_file"; fi
if [ -n "$globals_file" -a -r $globals_file ]; then cmd_base="$cmd_base --form globals=<$globals_file"; fi

# git command aped from https://github.com/jish/pre-commit/blob/master/lib/pre-commit/utils.rb
# grabs all the names of the files staged in the index
for file in $(git diff --cached --name-only --diff-filter=ACM | grep "\.js$"); do

	# Prevent console.log() or alert statements from being committed.
	# adapted from jlindley's console check https://gist.github.com/673376
	grep_bad=$(grep -inR "console\.\|alert(\|debugger" $file)
	count=$(echo -e "$grep_bad" | grep "[^\s]" | wc -l | awk '{print $1}')

	if [[ "$count" -ge 1 ]]; then
		echo "[warning] aborting commit" 1>&2
		echo "[warning] $count config.log/alert found:" 1>&2
		echo -e "$grep_bad" 1>&2
		exit 1
	fi

	# push the current file's contents to the jshint service
	hints=$($cmd_base --form "source=<$file" "$jshint_uri")
	on_error "couldn't connect to $jshint_uri"

	# if there's at least one line of output from the curl reponse
	# dump it to stdout for review
	counts=$(echo -e "$hints" | grep "[^\s]" | wc -l)
	if [[  "$counts" -gt 0 ]]; then
		echo
		echo "$file":
		echo "$hints"
	fi
done
