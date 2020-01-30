# sedtwentyone

## Description

sedtwentyone is a card game Twenty-One written in GNU sed.

Supported features:
* REPL user interface,
* cards ASCII-art,
* self-tests and functional tests,
* non-deterministic behavior,

Requirements:
* GNU sed needed to run. Tested on v4.7.
* GNU sed needed to be in PATH, that is a shell command 'sed' should work.
* Terminal size 80x25 recommended for the correct ASCII-art visualization.
* PRNG available through /dev/urandom.
* BATS (Bash test framework) required to run functional tests. Tested with v1.2.0.

Usage:
```
(run command)      $ ./sedtwentyone.sed
(press Return)     >>>
(program's output) <-< Supported commands in all modes:
                   <-< - help: display this help
                   <-< - quit: quits program
                   <-< - play: start game
                   <-< - rules: show game rules
                   <-< In game mode:
                   <-< - stand: stop dealing to player, dealer takes
                   <-< - hit: take one more card
                   <-<
(type 'play')      >>> play
(random result)    <-<  ____   ____
                   <-< |7   | |6   |
                   <-< |(\/)| | /\ |
                   <-< | \/ | |(__)|
                   <-< |   7| | /\6|
                   <-< `----' `----'
                   <-<
(type 'hit')       >>> hit
                   <-<  ____   ____   ____ 
                   <-< |7   | |6   | |4   |
                   <-< |(\/)| | /\ | | /\ |
                   <-< | \/ | |(__)| | \/ |
                   <-< |   7| | /\6| |   4|
                   <-< `----' `----' `----'
                   <-<
(type 'stand')     >>> stand
                   <-<
                   <-< Dealer's hand:
                   <-<  ____   ____ 
                   <-< |A   | |6   |
                   <-< | /\ | |(\/)|
                   <-< |(__)| | \/ |
                   <-< | /\A| |   6|
                   <-< `----' `----'
                   <-< 
                   <-< GAME OVER: Equal scores! TIE!
                   <-< 
                   <-< Supported commands in all modes:
                   <-< - help: display this help
                   <-< - quit: quits program
                   <-< - play: start game
                   <-< - rules: show game rules
                   <-< In game mode:
                   <-< - stand: stop dealing to player, dealer takes
                   <-< - hit: take one more card
                   <-< 
(type 'quit')      >>> quit
```

## Tests

### Unit tests
Activated by passing 'unit-test' input:
```
$ echo unit-test | ./sedtwentyone.sed 
OK: Self-tests passed!
```

### Functional tests
Activated by running BATS script:
```
$ ./test.sh 
 ✓ unitTests
 ✓ commandQuit
 ✓ commandHelp
 ✓ commandDebug
 ✓ commandRules
 ✓ commandPlay
 ✓ commandPlayHitOverflow
 ✓ commandPlayStand

8 tests, 0 failures
```

## Development

### Overview

There are a few concepts leveraged in the code:
* program state is stored line-wise in the hold space:
  * state is a list of key:value pairs,
  * used keys are:
    * stack: call stack which is a comma separated list of labels to return,
    * deck: cards in deck, each card is a word containing its nomial and suit,
    * playerHand: cards in player's hand,
    * dealerHand: cards in dealer's hand,
    * unit-test: specifies that self testing is active, limits side effects,
    * state: active mode of the program (if game is started),
    * pattern: stored snapshot of the pattern space for later re-use,
* user commands processor implemented with SED native address pattern matching:
  * active program determines behavior of the processor
* subroutine convention:
  * left-most label in a call stack continues first,
  * subroutine input passed in the pattern space,
  * subroutine output passed in the pattern space too,
  * state stored in the hold space might affect subroutine's behavior,
  * jumping to a subroutine gets done with branching commands: `b`, `t` or `T`,
  * returning from subroutine gets done with a common trampoline,
* whole code structured in subroutines,
  * each subroutine starts with a SED label specifying name of the subroutine,
  * most subroutines pass continuation with `trampoline`,
  * callback points are conventionally names `caller_after_callee`
    where `caller` and `callee` are names of the respective subroutines,
    suffix _N (where N is a consequetive index) can be appended in order to
    avoid collisions if required,
  * exceptions raised with a common `halt` subroutine,
* entry point is `main` subroutine.

### Style

Should be all clear from the script,
it is long enough to have plenty of examples.

### Non-determinism

Obviously Twenty-One card game requires non-determinism.
In its heart there is `getRandom` function. It reads out a line from
PRNG `/dev/urandom` and takes one decimal digit from it. If it happened that
the read data is not good, the process repeats. Theoretically it can repeat
forever.

Definitions:
* Line is a sequence of bytes terminating with `\n` character.
* Not good data is one that either unparsable, or does not contain any digits.
* Invalid multibyte sequences are unparsable by SED. In order to avoid this
  kind of soft failures, program can be run in single-byte locale,
  for example POSIX: `$ LC_ALL=C ./sedtwentyone.sed`

## Contacts and License

Distributed under terms of BSD license, available in LICENSE file.

Author is @Ygrex <ygrex@ygrex.ru>.

