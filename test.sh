#!/usr/bin/env bats

# Functional tests for sedtwentyone.sed
# CWD assumed to contain sedtwentyone.sed

# Wrapper to run sedtwentyone.sed as a function.
#
# Function parameters concatenated and sent to stdin for sedtwentyone.sed
# Example:
#	gameRunner 'unit-test'
# equivalent to shell command:
#	echo 'unit-test' | ./sedtwentyone.sed
gameRunner() {
	printf '%s\n' "$@" | ./sedtwentyone.sed
}

@test unitTests {
	run gameRunner unit-test
	[ "$status" -eq 0 ]
	[ "$output" = "OK: Self-tests passed!" ]
}

@test commandQuit {
	run gameRunner quit
	[ "$status" -eq 0 ]
	[ "$output" = "" ]
}

@test commandHelp {
	run gameRunner help
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "Supported commands in all modes:" ]
	[ "${lines[5]}" = "In game mode:" ]
}

@test commandDebug {
	run gameRunner debug
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "vvv DEBUG vvv" ]
	[ "${lines[4]}" = "^^^ DEBUG ^^^" ]
}

@test commandRules {
	run gameRunner rules
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "** Game Twenty-One **" ]
}

@test commandPlay {
	run gameRunner play
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = " ____   ____ " ]
	[ "${lines[5]}" = "\`----' \`----'" ]
}

@test commandPlayHitOverflow {
	run gameRunner play hit hit hit hit hit hit hit
	[ "$status" -eq 0 ]
	printf '%s\n' "$output" | grep -qFx 'GAME IS OVER, you are over 21!'
}

@test commandPlayStand {
	run gameRunner play stand
	[ "$status" -eq 0 ]
	printf '%s\n' "$output" | grep -q '^GAME.*OVER'
}

