#!/bin/sed -Enf

# Twenty-One card game written in GNU Sed.
# After running, any (even empty) user input entered with Return awaited.
# Sed does not have any script execution before the first line of input.
#
# Usage (run program and type 'play'):
#	$ ./sedtwentyone.sed
#	play
#	 ____   ____ 
#	|6   | |5   |
#	| /\ | | &  |
#	|(__)| |&|& |
#	| /\6| | | 5|
#	`----' `----'
#	quit

b main

# {{{ halt: quit on exception
# Shows content of pattern on hold spaces and exits with 1.
# By convention, all exceptions raised jump into this subroutine, so that
# script execution halts afterwards.
:halt
	s/^/EE: Exitting on exception!\n\nPattern:\n/
	s/$/\n\nHold:\n/
	G
	w /dev/stderr
	Q 1
# }}}

# {{{ showHelp: display help information to user
# Sends all user information to user on stdout.
# Neither pattern nor hold spaces affected.
# Subroutine does not return, runs the next cycle.
:showHelp
	i Supported commands in all modes:
	i - help: display this help
	i - quit: quits program
	i - play: start game
	i - rules: show game rules
	i In game mode:
	i - stand: stop dealing to player, dealer takes
	i - hit: take one more card
	i
	b
# }}}

# {{{ trampoline: return according to call stack
# Call stack is a line in the hold space of the following format:
#	stack:label1,label2,...labelN,\n
# Note that:
#	- each label has a trailing comma,
#	- no whitespaces allowed,
#	- each label refers to a label in the code.
# Trampoline subroutine cuts off the first left-most label1 and jumps into it.
# If label reference is not supported by the subroutine, an expection raised.
# After branching to labelX conditional flag is reset (the one tested by 't').
#
# Example of the callee - it just needs to finish by branshing to trampoline:
# :callee
#	... subroutine body ...
#	t trampoline
#
# Example of the caller:
# :caller
#	x ; s/^stack:/&caller_after_callee,/m ; x
#	b callee
#	:caller_after_callee
#	... code to be executed after callee finishes ...
#
# In order to make it working, that label 'caller_after_callee' should be
# added to this subroutine.
:trampoline
	t trampoline
	x
	s/^(stack:)resetDeck,/\1/m
		T trampoline_02
		x
		b resetDeck
	:trampoline_02
	s/^(stack:)pickRandomWord,/\1/m
		T trampoline_03
		x
		b pickRandomWord
	:trampoline_03
	s/^(stack:)pickMinWeightWords,/\1/m
		T trampoline_04
		x
		b pickMinWeightWords
	:trampoline_04
	s/^(stack:)attachRandomWeights_after_pushPattern,/\1/m
		T trampoline_05
		x
		b attachRandomWeights_after_pushPattern
	:trampoline_05
	s/^(stack:)attachRandomWeights_after_getRandom,/\1/m
		T trampoline_06
		x
		b attachRandomWeights_after_getRandom
	:trampoline_06
	s/^(stack:)attachRandomWeights_after_popPattern,/\1/m
		T trampoline_07
		x
		b attachRandomWeights_after_popPattern
	:trampoline_07
	s/^(stack:)popPattern,/\1/m
		T trampoline_09
		x
		b popPattern
	:trampoline_09
	s/^(stack:)dealCard_after_pickRandomWord,/\1/m
		T trampoline_10
		x
		b dealCard_after_pickRandomWord
	:trampoline_10
	s/^(stack:)dealCard_after_pushPattern,/\1/m
		T trampoline_11
		x
		b dealCard_after_pushPattern
	:trampoline_11
	s/^(stack:)dealCard_after_popPattern,/\1/m
		T trampoline_12
		x
		b dealCard_after_popPattern
	:trampoline_12
	s/^(stack:)dealPlayerCard,/\1/m
		T trampoline_13
		x
		b dealPlayerCard
	:trampoline_13
	s/^(stack:)startGame_after_secondCard,/\1/m
		T trampoline_14
		x
		b startGame_after_secondCard
	:trampoline_14
	s/^(stack:)gameTurn_after_hit,/\1/m
		T trampoline_15
		x
		b gameTurn_after_hit
	:trampoline_15
	s/^(stack:)displayPlayerHand,/\1/m
		T trampoline_16
		x
		b displayPlayerHand
	:trampoline_16
	s/^(stack:)startGame_after_countPlayerHand,/\1/m
		T trampoline_17
		x
		b startGame_after_countPlayerHand
	:trampoline_17
	s/^(stack:)gameTurn_after_countPlayerHand,/\1/m
		T trampoline_18
		x
		b gameTurn_after_countPlayerHand
	:trampoline_18
	s/^(stack:)gameTurn_after_stand,/\1/m
		T trampoline_19
		x
		b gameTurn_after_stand
	:trampoline_19
	s/^(stack:)dealPlayerCard_after_dealCard,/\1/m
		T trampoline_20
		x
		b dealPlayerCard_after_dealCard
	:trampoline_20
	s/^(stack:)dealDealerCard_after_dealCard,/\1/m
		T trampoline_21
		x
		b dealDealerCard_after_dealCard
	:trampoline_21
	s/^(stack:)displayDealerHand,/\1/m
		T trampoline_22
		x
		b displayDealerHand
	:trampoline_22
	s/^(stack:)dealDealerCard,/\1/m
		T trampoline_23
		x
		b dealDealerCard
	:trampoline_23
	s/^(stack:)countDealerHand,/\1/m
		T trampoline_24
		x
		b countDealerHand
	:trampoline_24
	s/^(stack:)pushPattern,/\1/m
		T trampoline_25
		x
		b pushPattern
	:trampoline_25
	s/^(stack:)countPlayerHand,/\1/m
		T trampoline_26
		x
		b countPlayerHand
	:trampoline_26
	s/^(stack:)endGameCompare_after_countDealerHand,/\1/m
		T trampoline_27
		x
		b endGameCompare_after_countDealerHand
	:trampoline_27
	s/^(stack:)unitTest_after_pickMinWeightWords,/\1/m
		T trampoline_28
		x
		b unitTest_after_pickMinWeightWords
	:trampoline_28
	s/^(stack:)unitTest_after_pickRandomWord,/\1/m
		T trampoline_29
		x
		b unitTest_after_pickRandomWord
	:trampoline_29
	s/^(stack:)unitTest_after_pushPattern,/\1/m
		T trampoline_30
		x
		b unitTest_after_pushPattern
	:trampoline_30
	s/^(stack:)unitTest_after_popPattern,/\1/m
		T trampoline_31
		x
		b unitTest_after_popPattern
	:trampoline_31
	s/^(stack:)unitTest_after_getRandom,/\1/m
		T trampoline_32
		x
		b unitTest_after_getRandom
	:trampoline_32
	s/^(stack:)unitTest_after_attachRandomWeights,/\1/m
		T trampoline_33
		x
		b unitTest_after_attachRandomWeights
	:trampoline_33
	s/^(stack:)unitTest_after_resetDeck,/\1/m
		T trampoline_34
		x
		b unitTest_after_resetDeck
	:trampoline_34
	s/^(stack:)unitTest_after_dealCard,/\1/m
		T trampoline_35
		x
		b unitTest_after_dealCard
	:trampoline_35
	s/^(stack:)unitTest_after_dealPlayerCard,/\1/m
		T trampoline_36
		x
		b unitTest_after_dealPlayerCard
	:trampoline_36
	s/^(stack:)unitTest_after_dealDealerCard,/\1/m
		T trampoline_37
		x
		b unitTest_after_dealDealerCard
	:trampoline_37
	s/^(stack:)unitTest_after_displayHand,/\1/m
		T trampoline_38
		x
		b unitTest_after_displayHand
	:trampoline_38
	s/^(stack:)unitTest_after_displayPlayerHand,/\1/m
		T trampoline_39
		x
		b unitTest_after_displayPlayerHand
	:trampoline_39
	s/^(stack:)unitTest_after_displayDealerHand,/\1/m
		T trampoline_40
		x
		b unitTest_after_displayDealerHand
	:trampoline_40
	s/^(stack:)unitTest_after_sumIntegers_simple,/\1/m
		T trampoline_41
		x
		b unitTest_after_sumIntegers_simple
	:trampoline_41
	s/^(stack:)unitTest_after_sumIntegers_overflow,/\1/m
		T trampoline_42
		x
		b unitTest_after_sumIntegers_overflow
	:trampoline_42
	s/^(stack:)unitTest_after_countHand,/\1/m
		T trampoline_43
		x
		b unitTest_after_countHand
	:trampoline_43
	s/^(stack:)unitTest_after_countPlayerHand,/\1/m
		T trampoline_44
		x
		b unitTest_after_countPlayerHand
	:trampoline_44
	s/^(stack:)unitTest_after_countDealerHand,/\1/m
		T trampoline_45
		x
		b unitTest_after_countDealerHand
	:trampoline_45
	s/^(stack:)unitTest_after_endGameCompare_tie,/\1/m
		T trampoline_46
		x
		b unitTest_after_endGameCompare_tie
	:trampoline_46
	s/^(stack:)unitTest_after_endGameCompare_dealerWins,/\1/m
		T trampoline_47
		x
		b unitTest_after_endGameCompare_dealerWins
	:trampoline_47
	s/^(stack:)unitTest_after_endGameCompare_playerWins,/\1/m
		T trampoline_48
		x
		b unitTest_after_endGameCompare_playerWins
	:trampoline_48
	:trampoline_halt
		x
		i trampoline: Unexpected callback!
		b halt
# }}}

# {{{ pickMinWeightWords: pick words with a minimum weight 
# Assume words are alpha-numeric with weights of form _N attached, where
# N is a weight for 0 to 9. The subroutine picks words with the minimum
# weight, removes other words and cuts off weights.
#
# Example input:
# lorem_4 ipsum_1 dolor_4 sit_1
#
# Example output:
# ipsum_1 sit_1
:pickMinWeightWords
	t pickMinWeightWords
	s/(\w+_)0/\1/g
	t pickMinWeightWords_done
	s/(\w+_)1/\1/g
	t pickMinWeightWords_done
	s/(\w+_)2/\1/g
	t pickMinWeightWords_done
	s/(\w+_)3/\1/g
	t pickMinWeightWords_done
	s/(\w+_)4/\1/g
	t pickMinWeightWords_done
	s/(\w+_)5/\1/g
	t pickMinWeightWords_done
	s/(\w+_)6/\1/g
	t pickMinWeightWords_done
	s/(\w+_)7/\1/g
	t pickMinWeightWords_done
	s/(\w+_)8/\1/g
	t pickMinWeightWords_done
	s/(\w+_)9/\1/g
	t pickMinWeightWords_done
	i pickMinWeightWords: no weighted words found!
	b halt
	:pickMinWeightWords_done
		s/\s*\w+_[0-9]\s*/ /g
		s/(\w+)_\b/\1/g
		s/^\s+//
		s/\s+$//
	:pickMinWeightWords_squeeze
		s/\s\s+/ /
		t pickMinWeightWords_squeeze
	b trampoline
# }}}

# {{{ pickRandomWord: randomly pick one word
# Given a text of words, subroutine leaves one by random.
# Example input:
#	lorem ipsum dolor sit amen
# Example output:
#	sit
:pickRandomWord
	# trim spaces on a line
	s/^\W+//
	s/\W+$//
	t pickRandomWord
	# one or no words on a line is a stop condition
	s/^\w*$/&/
	t trampoline
	x ; s/^stack:/&pickMinWeightWords,pickRandomWord,/m ; x
	b attachRandomWeights
# }}}

# {{{ pushPattern: serialize pattern space in one line, keep it in hold space
# All pattern content gets serialized in one line, prepended with 'pattern:'
# tag and stored at the bottom of the hold space.
# Serialization is as simple as converting all \n to \x01, that means that
# this special marker \x01 should not be used for any other purposes across
# all the rest of the code.
# Pattern content is preserved by the subroutine return.
# Example input:
#	lorem ipsum
#	dolor sit amet
# Example effect in the hold space:
#	pattern:lorem ipsum\x01dolor sit amet
:pushPattern
	s/\n/\x01/g
	s/^/pattern:/
	H
	s/^pattern://
	s/\x01/\n/g
	b trampoline
# }}}

# {{{ popPattern: take out serialized pattern from the hold space
# Restore the latest pattern kept with pushPattern.
# To the content of the pattern space a newline added and the latest saved
# pattern content appended.
# The restored pattern data gets removed (popped out) from the hold space.
# No input expected, but the pattern content stored in the hold space.
:popPattern
	# serialize pattern
	s/\n/\x01/g
	s/^/pattern:/
	G
	:popPattern_noop_01
	t popPattern_noop_01
	# keep this original data
	# append newline
	# add the last pattern from the hold space
	# remove all other lines in the pattern space
	s/^(pattern:[^\n]*\n).*\n?(pattern:[^\n]*)(\n.*)?$/\1\2/
	T popPattern_failed_to_retrieve
	# deserialize both lines
	s/^pattern://mg
	s/\x01/\n/g
	:popPattern_noop_02
	t popPattern_noop_02
	# remove the retrieved line from the hold space
	x
	s/^(.*\n)?pattern:[^\n]*\n*(.*)?$/\1\2/
	x
	T popPattern_failed_to_remove
	x ; s/\n+$// ; x
	b trampoline
	:popPattern_failed_to_retrieve
		i popPattern: failed to retrieve data from the hold space!
		b halt
	:popPattern_failed_to_remove
		i popPattern: failed to remove data from the hold space!
		b halt
# }}}

# {{{ getRandom: fetch one random digit
# Pattern content gets all replaced with a single random decimal digit.
# Subroutine waits until the whole line assembled from a random source,
# which theoretically might long forever.
# No input expected.
# Example output:
#	0
:getRandom
	z
	# The following pattern:
	# - skips lines with no digits,
	# - might match lines with invalid multibyte characters
	# - picks the last digit on a line
	s@^@sed -Ene 's/^.*([0-9]).*$/\\1/p;T;Q' /dev/urandom@
	e
	:getRandom_noop
	t getRandom_noop
	# check if any invalid multibyte characters
	s/^[0-9]$/&/
	T getRandom
	b trampoline
# }}}

# {{{ attachRandomWeights: add weights to words
# Appends _N labels to each given word where N is a random digit.
# Example input:
#	lorem ipsum dolor sit amet
# Example output:
#	lorem_2 ipsum_9 dolor_0 sit_9 amet_3
:attachRandomWeights
	# append __ (double underscore) to each word for a weight holder
	s/\w+/&__/g
	:attachRandomWeights_loop
		x ; s/^stack:/&attachRandomWeights_after_pushPattern,/m ; x
		b pushPattern
		:attachRandomWeights_after_pushPattern
		x ; s/^stack:/&attachRandomWeights_after_getRandom,/m ; x
		b getRandom
		:attachRandomWeights_after_getRandom
		x ; s/^stack:/&attachRandomWeights_after_popPattern,/m ; x
		b popPattern
		:attachRandomWeights_after_popPattern
		# First line contains a random digit,
		# second line contains weighted input words.
		# Mark the last unmarked word with the digit and
		# remove the first line.
		s/([0-9])\n(.*)__/\2_\1/
		t attachRandomWeights_loop
	s/^[0-9]\n//
	b trampoline
# }}}

# {{{ resetDeck: reset cards deck
# Save a full pack of 52 cards in the hold space.
# Any other deck gets deleted if found in the hold space.
# Pattern content gets destroyed.
# No input expected.
# A fresh deck in the hold space prefixed with 'deck:' tag.
# Cards a symbolically stored as <value>_<suit> where:
#	<value> is 2..10 or A, J, Q, K for Aces, Jack, Queen or King.
#	<suit> is c, d, h or s for Clubs, Diamonds, Hearts and Spades.
# Example stored deck:
#	deck:2c 3c ... Ks As
:resetDeck
	z
	# One default suite of cards
	s/^/2_ 3_ 4_ 5_ 6_ 7_ 8_ 9_ 10_ J_ Q_ K_ A_\n/
	# Copy to four suites
	s/^.+\n/&&&&/
	# First row for clubs
	:resetDeck_set_clubs
		s/^([^\n]*)_/\1c/
		t resetDeck_set_clubs
	# Second row for diamonds
	:resetDeck_set_diamonds
		s/^([^\n]+\n[^\n]*)_/\1d/
		t resetDeck_set_diamonds
	# Third row for hearts
	:resetDeck_set_hearts
		s/^(([^\n]+\n){2}[^\n]*)_/\1h/
		t resetDeck_set_hearts
	# Fourth row for spades
	:resetDeck_set_spades
		s/^(([^\n]+\n){3}[^\n]*)_/\1s/
		t resetDeck_set_spades
	# Make it in one row
	s/\n/ /g
	# Add prefix to lookup in the hold space
	s/^.*$/deck:&/
	# Deck line is in the following form here:
	#	^deck:2c 3c ... Ks As$	
	# Now it is required to remove a stored deck if any
	x
	:resetDeck_remove_state
		s/^deck:.*$//m
		s/\n\n+/\n/
		s/^\n+//
		s/\n+$//
		t resetDeck_remove_state
	x
	H
	b trampoline
# }}}

# {{{ dealCard: deal a random card out of a deck
# deck and hand are expected to be retieved in the pattern space yet.
# Example input:
#	_deck:As Ah
#	_hand:10d
# Example output:
#	_deck: Ah
#	_hand:10d As
:dealCard
	# save deck and hand for later use
	x ; s/^stack:/&dealCard_after_pushPattern,/m ; x
	b pushPattern
	:dealCard_after_pushPattern
	# leave only a deck for a while
	s/^_hand:.*$//m
	s/^_deck://m
	x ; s/^stack:/&dealCard_after_pickRandomWord,/m ; x
	b pickRandomWord
	:dealCard_after_pickRandomWord
	x ; s/^stack:/&dealCard_after_popPattern,/m ; x
	b popPattern
	:dealCard_after_popPattern
	# Here 1st line contains a dealt card,
	# and two lines follow in any order: deck and hand.
	# The dealt card is to be:
	# 1. removed from the deck
	# 2. added to a hand
	# Remove from the deck:
	s/^(\w+)(.*\n_deck:[^\n]*)\b\1\b/\1\2/
	T dealCard_failed_remove
	# Add to a hand and empty the 1st line:
	s/^(\w+)(.*\n_hand:[^\n]*)/\2 \1/
	T dealCard_failed_add
	# deck and hand updated in the pattern space
	b trampoline
	:dealCard_failed_remove
		i dealCard: failed to remove card from a deck!
		b halt
	:dealCard_failed_add
		i dealCard: failed to add card to a hand!
		b halt
# }}}

# {{{ dealPlayerCard: deal a card to player
# Takes a random card of the saved deck to player's hand.
# Both stored in the hold space with deck: and playerHand: tags
# correspondingly.
# Pattern content gets destroyed.
# No input expected.
#
# Example state in the hold space:
#	deck:10s
#	playerHand:9s
# Example effect in the hold space:
#	deck:
#	playerHand:10s 9s
:dealPlayerCard
	# retrieve a deck and player's hand from the hold space
	g
	s/^deck:/_&/m
	s/^playerHand:/_hand:/m
	s/^[^_].*$//mg
	x ; s/^stack:/&dealPlayerCard_after_dealCard,/m ; x
	b dealCard
	:dealPlayerCard_after_dealCard
	# Replace deck and a hand in the hold space
	G
	s/^playerHand:.*$//mg
	s/^deck:.*$//mg
	s/_deck:/deck:/mg
	s/^_hand:/playerHand:/mg
	h
	b trampoline
	:dealPlayerCard_failed_remove
		i dealPlayerCard: failed to remove card from a deck!
		b halt
	:dealPlayerCard_failed_add
		i dealPlayerCard: failed to add card to a hand!
		b halt
# }}}

# {{{ dealDealerCard: deal a card to dealer
# The same as dealPlayerCard but deals to dealer's hand which is stored with
# dealerHand: tag in the hold space.
# Pattern content gets destroyed.
# No input expected.
#
# Example state in the hold space:
#	deck:10s
#	dealerHand:9s
# Example effect in the hold space:
#	deck:
#	dealerHand:10s 9s
:dealDealerCard
	# retrieve a deck and player's hand from the hold space
	g
	s/^deck:/_&/m
	s/^dealerHand:/_hand:/m
	s/^[^_].*$//mg
	x ; s/^stack:/&dealDealerCard_after_dealCard,/m ; x
	b dealCard
	:dealDealerCard_after_dealCard
	# Replace deck and a hand in the hold space
	G
	s/^dealerHand:.*$//mg
	s/^deck:.*$//mg
	s/_deck:/deck:/mg
	s/^_hand:/dealerHand:/mg
	h
	b trampoline
	:dealDealerCard_failed_remove
		i dealDealerCard: failed to remove card from a deck!
		b halt
	:dealDealerCard_failed_add
		i dealDealerCard: failed to add card to a hand!
		b halt
# }}}

# {{{ displayHand: picture a hand
# An expected input is a hand to picture in symbols from resetDeck.
# ASCII-art pictures replace the given hand in the pattern space.
# Source: https://ascii.co.uk/art/cards
# Deck pictures:
#  ____    ____    ____    ____
# |2   |  |A   |  |Q   |  |T   |
# |(\/)|  | /\ |  | /\ |  | &  |
# | \/ |  | \/ |  |(__)|  |&|& |
# |   2|  |   A|  | /\Q|  | | T|     en Bukkems
# `----`  `----'  `----'  `----'
# Example input for the pictures above:
#	2h Ad Qs Jc
:displayHand
	s/\n//g
	s/\s\s+/\s/g
	s/^\s+//
	s/\s+$//
	t displayHand
	# Cards are six rows height:
	s/^.*$/&\n&\n&\n&\n&\n&\n/
	# First row is common for all suits:
	:displayHand_firstRow
		s/^([^\n]*)\<[[:alnum:]]+/\1 ____ /
		t displayHand_firstRow
	# Second row does only indicate value, not a suit:
	:displayHand_secondRow
		# 2-chars:
		s/^([^\n]+\n[^\n]*)\<([[:alnum:]][[:alnum:]])[[:lower:]]\>/\1|\2  |/
		# 1-char:
		s/^([^\n]+\n[^\n]*)\<([[:alnum:]])[[:lower:]]\>/\1|\2   |/
		t displayHand_secondRow
	:displayHand_thirdRow
		# hearts:
		s,^([^\n]+\n[^\n]+\n[^\n]*)\<[[:alnum:]]+h\>,\1|(\\/)|,
		# diamonds or spades:
		s,^([^\n]+\n[^\n]+\n[^\n]*)\<[[:alnum:]]+[ds]\>,\1| /\\ |,
		# clubs:
		s,^([^\n]+\n[^\n]+\n[^\n]*)\<[[:alnum:]]+c\>,\1| \&  |,
		t displayHand_thirdRow
	:displayHand_fourthRow
		# hearts or diamonds:
		s,^([^\n]+\n[^\n]+\n[^\n]+\n[^\n]*)\<[[:alnum:]]+[hd]\>,\1| \\/ |,
		# spades:
		s,^([^\n]+\n[^\n]+\n[^\n]+\n[^\n]*)\<[[:alnum:]]+s\>,\1|(__)|,
		# clubs:
		s,^([^\n]+\n[^\n]+\n[^\n]+\n[^\n]*)\<[[:alnum:]]+c\>,\1|\&|\& |,
		t displayHand_fourthRow
	:displayHand_fifthRow
		# hearts or diamonds 1-char:
		s,^([^\n]+\n[^\n]+\n[^\n]+\n[^\n]+\n[^\n]*)\<([[:alnum:]])[hd]\>,\1|   \2|,
		# hearts or diamonds 2-chars:
		s,^([^\n]+\n[^\n]+\n[^\n]+\n[^\n]+\n[^\n]*)\<([[:alnum:]]{2})[hd]\>,\1|  \2|,
		# spades 1-char:
		s,^([^\n]+\n[^\n]+\n[^\n]+\n[^\n]+\n[^\n]*)\<([[:alnum:]])s\>,\1| /\\\2|,
		# spades 2-chars:
		s,^([^\n]+\n[^\n]+\n[^\n]+\n[^\n]+\n[^\n]*)\<([[:alnum:]]{2})s\>,\1| /\\\2,
		# clubs 1-char:
		s,^([^\n]+\n[^\n]+\n[^\n]+\n[^\n]+\n[^\n]*)\<([[:alnum:]])c\>,\1| | \2|,
		# clubs 2-chars:
		s,^([^\n]+\n[^\n]+\n[^\n]+\n[^\n]+\n[^\n]*)\<([[:alnum:]]{2})c\>,\1| | \2,
		t displayHand_fifthRow
	# Sixth row is common for all suits:
	:displayHand_sixthRow
		s,^([^\n]+\n[^\n]+\n[^\n]+\n[^\n]+\n[^\n]+\n[^\n]*)\<[[:alnum:]]+\>,\1`----',
		t displayHand_sixthRow
	b trampoline
# }}}

# {{{ displayPlayerHand: picture player's hand
# Retrieve player's hand from the hold space and call displayHand.
# Content of the pattern space gets replaced.
:displayPlayerHand
	g
	s/^playerHand:/_&/m
	s/^[^_].*$//mg
	s/^_playerHand://m
	b displayHand
# }}}

# {{{ displayDealerHand: picture dealer's hand
# Retrieve dealer's hand from the hold space and call displayHand.
# Content of the pattern space gets replaced.
:displayDealerHand
	g
	s/^dealerHand:/_&/m
	s/^[^_].*$//mg
	s/^_dealerHand://m
	b displayHand
# }}}

# {{{ sumIntegers: evaluate sum of all specified integers
# Only integers referring to twenty-one scores allowed: 1..21
# If sum is greater than 21, result is 'overflow' word.
# Pattern space gets fully replaced.
# Example input:
#	1 10 15
# Example output:
#	overflow
:sumIntegers
	# first, convert to unary
	s/\<1\>/u1/g
	s/\<2\>/u11/g
	s/\<3\>/u111/g
	s/\<4\>/u1111/g
	s/\<5\>/u11111/g
	s/\<6\>/u111111/g
	s/\<7\>/u1111111/g
	s/\<8\>/u11111111/g
	s/\<9\>/u111111111/g
	s/\<10\>/u1111111111/g
	s/\<11\>/u11111111111/g
	s/\<12\>/u111111111111/g
	s/\<13\>/u1111111111111/g
	s/\<14\>/u11111111111111/g
	s/\<15\>/u111111111111111/g
	s/\<16\>/u1111111111111111/g
	s/\<17\>/u11111111111111111/g
	s/\<18\>/u111111111111111111/g
	s/\<19\>/u1111111111111111111/g
	s/\<20\>/u11111111111111111111/g
	s/\<21\>/u111111111111111111111/g
	:sumIntegers_check_overflow
		t sumIntegers_check_overflow
		s/\<[[:digit:]]+\>/&/
		t sumIntegers_overflow
	:sumIntegers_pair
		s/(u[01]+)\s+u([01]+)\>/\1\2/
		t sumIntegers_pair
	:sumIntegers_clean
		s/\s+//g
		t sumIntegers_clean
	# convert back to decimal
	s/u1\>/1/ ; t trampoline
	s/u1{2}\>/2/ ; t trampoline
	s/u1{3}\>/3/ ; t trampoline
	s/u1{4}\>/4/ ; t trampoline
	s/u1{5}\>/5/ ; t trampoline
	s/u1{6}\>/6/ ; t trampoline
	s/u1{7}\>/7/ ; t trampoline
	s/u1{8}\>/8/ ; t trampoline
	s/u1{9}\>/9/ ; t trampoline
	s/u1{10}\>/10/ ; t trampoline
	s/u1{11}\>/11/ ; t trampoline
	s/u1{12}\>/12/ ; t trampoline
	s/u1{13}\>/13/ ; t trampoline
	s/u1{14}\>/14/ ; t trampoline
	s/u1{15}\>/15/ ; t trampoline
	s/u1{16}\>/16/ ; t trampoline
	s/u1{17}\>/17/ ; t trampoline
	s/u1{18}\>/18/ ; t trampoline
	s/u1{19}\>/19/ ; t trampoline
	s/u1{20}\>/20/ ; t trampoline
	s/u1{21}\>/21/ ; t trampoline
	:sumIntegers_overflow
		s/^.*$/overflow/
		b trampoline
# }}}

# {{{ countHand: evaluate nominal of a hand
:countHand
	# suit does not affect value, strip it off
	s/[[:lower:]]//g
	# aces are 11
	s/A/11/g
	# other court cards are 10
	s/[[:upper:]]/10/g
	b sumIntegers
# }}}

# {{{ countPlayerHand: evaluate nominal of player's hand
:countPlayerHand
	# retrieve player's hand from the hold space
	g
	s/^playerHand:/_&/m
	s/^[^_].*$//mg
	s/^\n*_playerHand://
	b countHand
# }}}

# {{{ countDealerHand: evaluate nominal of player's hand
:countDealerHand
	# retrieve dealer's hand from the hold space
	g
	s/^dealerHand:/_&/m
	s/^[^_].*$//mg
	s/^\n*_dealerHand://
	b countHand
# }}}

# {{{ endGameCompare: compare hands and over the game
# Compares scores for player's and dealer's hands,
# concludes the game result, resets the game state, triggers the next cycle.
# No input expected.
# Pattern space content get replaced with the game result (who wins).
# In self-test mode no text is sent to stdout, returns by trampoline.
# Example state in the hold space:
#	dealerHand:Ad 4s 5h
#	playerHand:Ad 4s 5h
# Example output:
#	GAME OVER: Equal scores! TIE!
:endGameCompare
	x ; s/^stack:/&countDealerHand,pushPattern,countPlayerHand,popPattern,endGameCompare_after_countDealerHand,/m ; x
	b trampoline
	:endGameCompare_after_countDealerHand
	# There are two lines with hands nominals,
	# first for player's one, second for dealer's
	# player overflow detected earlier, check dealer's overflow here:
	s/^overflow/&/m
	t endGameCompare_dealer_overflow
	# compare integers by length first
	s/^[[:digit:]]\n[[:digit:]][[:digit:]]/&/
	t endGameCompare_dealer_more
	s/^[[:digit:]][[:digit:]]\n[[:digit:]]\>/&/
	t endGameCompare_player_more
	# try comparing 2-digit integers
	s/^1[[:digit:]]\n2[[:digit:]]/&/
	t endGameCompare_dealer_more
	s/^2[[:digit:]]\n1[[:digit:]]/&/
	t endGameCompare_player_more
	# remove first digit if any and compare by tail
	s/^[[:digit:]]([[:digit:]]\n)[[:digit:]]([[:digit:]])/\1\2/
	:endGameCompare_noop_1
		t endGameCompare_noop_1
	s/^([[:digit:]])\n\1/&/
	t endGameCompare_equal
	s/^[0-8]\n9/&/
	t endGameCompare_dealer_more
	s/^[0-7]\n[8-9]/&/
	t endGameCompare_dealer_more
	s/^[0-6]\n[7-9]/&/
	t endGameCompare_dealer_more
	s/^[0-5]\n[6-9]/&/
	t endGameCompare_dealer_more
	s/^[0-4]\n[5-9]/&/
	t endGameCompare_dealer_more
	s/^[0-3]\n[4-9]/&/
	t endGameCompare_dealer_more
	s/^[0-2]\n[3-9]/&/
	t endGameCompare_dealer_more
	s/^[0-1]\n[2-9]/&/
	s/^0\n[1-9]/&/
	t endGameCompare_dealer_more
	b endGameCompare_player_more
	:endGameCompare_equal
		z ; s/^/GAME OVER: Equal scores! TIE!/
		b endGameCompare_over
	:endGameCompare_player_more
		z ; s/^/GAME OVER: YOU WON!/
		b endGameCompare_over
	:endGameCompare_dealer_more
		z ; s/^/GAME OVER: Dealer WON!/
		b endGameCompare_over
	:endGameCompare_dealer_overflow
		z ; s/^/GAME OVER: Dealer got over 21! YOUR WIN!/
		b endGameCompare_over
	:endGameCompare_over
		t endGameCompare_over
		x ; s/^unit-test:unit-test$/&/m ; x
		t trampoline
		p
		i
		z
		h
		b showHelp
# }}}

# {{{ endGameOverflow: player is over 21
# Inform player that they got more than 21,
# reset game state, display general help info and run the next cycle.
# No input expected.
# Both pattern and hold spaces cleaned up.
:endGameOverflow
	i GAME IS OVER, you are over 21!
	i
	z
	h
	b showHelp
# }}}

# {{{ startGame: initialize a game state and deal first cards
# No input expected.
# Any content in pattern and hold spaces gets re-written.
:startGame
	t startGame
	x
	z
	s/^/state:game,\nstack:\nplayerHand:\ndealerHand:/
	x
	x ; s/^stack:/&resetDeck,dealPlayerCard,dealPlayerCard,displayPlayerHand,startGame_after_secondCard,/m ; x
	b trampoline
	:startGame_after_secondCard
		p
	x ; s/^stack:/&startGame_after_countPlayerHand,/m ; x
	b countPlayerHand
	:startGame_after_countPlayerHand
		s/^overflow//
		t endGameOverflow
	b
# }}}

# {{{ debug: show state and trigger the next cycle
# Sends whole the current state to stdout and runs the next cycle.
# No input expected.
# Any content in pattern and hold space preserved.
:debug
	i vvv DEBUG vvv
	i Pattern:
	p
	i Hold:
	x ; p ; x
	i ^^^ DEBUG ^^^
	b
# }}}

# {{{ showRules: show rules and trigger the next cycle
# Sends game rules description to stdout and runs the next cycle.
# No input expected.
# Any content in pattern and hold space preserved.
:showRules
	i
	i ** Game Twenty-One **
	i
	i Twenty-one is a card game.
	i Played with a pack of 52 cards.
	i Each card is valued by its nominal, aces are 11, court cards are worth 10.
	i There are two roles in a game: player (human) and dealer (computer).
	i At the beginning of a game player gets two cards and can proceed
	i either with 'stand' or 'hit'.
	i 'hit' means that dealer gives one more card to a player.
	i 'stand' meand that player keeps their hand and it is dealer's turn.
	i Dealer on their turn takes two cards and game ends.
	i Whenever a player collects a hand worth more than 21, they loose.
	i At the end of the game scores compared.
	i Wins the one who has more scores, but not more than 21.
	i
	b
# }}}

# {{{ initStart: process command in initial program mode
# Process user's input as a command in initial program mode
# while game is not yet started.
# Any unsupported command shows a help information.
# User input is expected in the pattern space.
# Subroutine does not return but jumps to other subroutine according to input.
:initStart
	/^quit$/ Q
	/^play$/ b startGame
	/^debug$/ b debug
	/^rules$/ b showRules
	b showHelp
# }}}

# {{{ gameTurn: process in a game mode
# Process user's input as a command in a game mode.
# Any unsupported command shows a help information.
# User input is expected in the pattern space.
# Subroutine does not return but jumps to other subroutine according to input
# or triggers the next cycle.
:gameTurn
	/^quit$/ Q
	/^play$/ b startGame
	/^debug$/ b debug
	/^rules$/ b showRules
	/^hit$/ {
		x ; s/^stack:/&displayPlayerHand,gameTurn_after_hit,/m ; x
		b dealPlayerCard
		:gameTurn_after_hit
			p
		x ; s/^stack:/&gameTurn_after_countPlayerHand,/m ; x
		b countPlayerHand
		:gameTurn_after_countPlayerHand
			s/^overflow/&/
			t endGameOverflow
		b
	}
	/^stand$/ {
		# simply give two cards to dealer and compare who have more
		x ; s/^stack:/&dealDealerCard,displayDealerHand,gameTurn_after_stand,/m ; x
		b dealDealerCard
		:gameTurn_after_stand
			i
			i Dealer's hand:
			p
		b endGameCompare
	}
	b showHelp
# }}}

# {{{ unitTest: enty-point to self-tests
# Data in hold and pattern spaces will be emptied.
# No input expected.
# Subroutine does not return, but runs the next cycle.
:unitTest
	z ; s/^/stack:unitTest_after_pickMinWeightWords,/ ; h
	z ; s/^/lorem_2 ipsum_9 dolor_0 sit_1 amet_0/
	b pickMinWeightWords
	:unitTest_after_pickMinWeightWords
		s/\<dolor\>//
		T unitTest_failed_pickMinWeightWords
		s/\<amet\>//
		T unitTest_failed_pickMinWeightWords
		s/^\s*$//
		T unitTest_failed_pickMinWeightWords
	z ; s/^/stack:unitTest_after_pickRandomWord,/ ; h
	z ; s/^/lorem ipsum dolor sit amet/
	b pickRandomWord
	:unitTest_after_pickRandomWord
		s/\<(lorem|ipsum|dolor|sit|amet)\>//
		T unitTest_failed_pickRandomWord
		s/^\s*$//
		T unitTest_failed_pickRandomWord
	z ; s/^/stack:unitTest_after_pushPattern,/ ; h
	z ; s/^/lorem ipsum\ndolor sit\namet\n/
	b pushPattern
	:unitTest_after_pushPattern
		s/^lorem ipsum\ndolor sit\namet\n$//
		T unitTest_failed_pushPattern
		x
		s/^pattern:lorem ipsum\x01dolor sit\x01amet\x01$//m
		T unitTest_failed_pushPattern
	z ; s/^/stack:unitTest_after_popPattern,/ ; h
	z ; s/^/pattern:lorem ipsum\x01dolor/ ; H
	z ; s/^/pattern:\x01lo\x01rem ip\x01sum\x01/ ; H
	z ; s/^/lorem ipsum\n/
	b popPattern
	:unitTest_after_popPattern
		s/^lorem ipsum\n\n\nlo\nrem ip\nsum\n//
		T unitTest_failed_popPattern
		x
		s/^pattern:\x01lo//m
		t unitTest_failed_popPattern
	z ; s/^/stack:unitTest_after_getRandom,/ ; h
	b getRandom
	:unitTest_after_getRandom
		s/^[0-9]$//
		T unitTest_failed_getRandom
	z ; s/^/stack:unitTest_after_attachRandomWeights,/ ; h
	z ; s/^/  lorem  ipsum dolor sit amet\n/
	b attachRandomWeights
	:unitTest_after_attachRandomWeights
		s/\<lorem_[[:digit:]]\>//
		T unitTest_failed_attachRandomWeights
		s/\<ipsum_[[:digit:]]\>//
		T unitTest_failed_attachRandomWeights
		s/\<dolor_[[:digit:]]\>//
		T unitTest_failed_attachRandomWeights
		s/\<sit_[[:digit:]]\>//
		T unitTest_failed_attachRandomWeights
		s/\<amet_[[:digit:]]\>//
		T unitTest_failed_attachRandomWeights
		s/^[\n ]*$//
		T unitTest_failed_attachRandomWeights
	z ; s/^/stack:unitTest_after_resetDeck,/ ; h
	z ; s/^/deck:Qs Kh/ ; H
	b resetDeck
	:unitTest_after_resetDeck
		g
		s/^deck:(\<\w+\>\s+){51}\<\w+\>//m
		T unitTest_failed_resetDeck
		s/^deck://m
		t unitTest_failed_resetDeck
	z ; s/^/stack:unitTest_after_dealCard,/ ; h
	z
	s/^/_deck:As Ah Ad Ac\n/
	s/^/_hand:10s\n/
	b dealCard
	:unitTest_after_dealCard
		s/^_deck:\s*(A\w\s+){2}A\w\s*$//m
		T unitTest_failed_dealCard
		s/^(_hand:.*)A\w/\1/m
		T unitTest_failed_dealCard
		s/^(_hand:.*)10s/\1/m
		T unitTest_failed_dealCard
		s/^_hand:\s*$//m
		T unitTest_failed_dealCard
	z ; s/^/stack:unitTest_after_dealPlayerCard,/ ; h
	z
	s/^/deck:As\n/
	s/^/playerHand:10d\n/
	H
	b dealPlayerCard
	:unitTest_after_dealPlayerCard
		g
		s/^deck:\s*$//m
		T unitTest_failed_dealPlayerCard
		s/^(playerHand:.*)10d/\1/m
		T unitTest_failed_dealPlayerCard
		s/^(playerHand:.*)As/\1/m
		T unitTest_failed_dealPlayerCard
		s/^playerHand:\s*$//m
		T unitTest_failed_dealPlayerCard
	z ; s/^/stack:unitTest_after_dealDealerCard,/ ; h
	z
	s/^/deck:As\n/
	s/^/dealerHand:10d\n/
	H
	b dealDealerCard
	:unitTest_after_dealDealerCard
		g
		s/^deck:\s*$//m
		T unitTest_failed_dealDealerCard
		s/^(dealerHand:.*)10d/\1/m
		T unitTest_failed_dealDealerCard
		s/^(dealerHand:.*)As/\1/m
		T unitTest_failed_dealDealerCard
		s/^dealerHand:\s*$//m
		T unitTest_failed_dealDealerCard
	z ; s/^/stack:unitTest_after_displayHand,/ ; h
	z ; s/^/2h Ad Qs Jc/
	b displayHand
	:unitTest_after_displayHand
		s,^ ____   ____   ____   ____ \n,,
		T unitTest_failed_displayHand
		s,^\|2   \| \|A   \| \|Q   \| \|J   \|\n,,
		T unitTest_failed_displayHand
		s,^\|\(\\/\)\| \| /\\ \| \| /\\ \| \| &  \|\n,,
		T unitTest_failed_displayHand
		s,^\| \\/ \| \| \\/ \| \|\(__\)\| \|&\|& \|\n,,
		T unitTest_failed_displayHand
		s,^\|   2\| \|   A\| \| /\\Q\| \| \| J\|\n,,
		T unitTest_failed_displayHand
		s,^`----' `----' `----' `----',,
		T unitTest_failed_displayHand
		s,^[\n ]*$,,
		T unitTest_failed_displayHand
	z ; s/^/stack:unitTest_after_displayPlayerHand,/ ; h
	z ; s/^/playerHand:2h Ad Qs Jc/ ; H
	b displayPlayerHand
	:unitTest_after_displayPlayerHand
		s,^ ____   ____   ____   ____ \n,,
		T unitTest_failed_displayPlayerHand
		s,\n`----' `----' `----' `----'[\n ]*$,,
		T unitTest_failed_displayPlayerHand
	z ; s/^/stack:unitTest_after_displayDealerHand,/ ; h
	z ; s/^/dealerHand:2h Ad Qs Jc/ ; H
	b displayDealerHand
	:unitTest_after_displayDealerHand
		s,^ ____   ____   ____   ____ \n,,
		T unitTest_failed_displayDealerHand
		s,\n`----' `----' `----' `----'[\n ]*$,,
		T unitTest_failed_displayDealerHand
	z ; s/^/stack:unitTest_after_sumIntegers_simple,/ ; h
	z ; s/^/1 15 5/
	b sumIntegers
	:unitTest_after_sumIntegers_simple
		s/^\s*21\s*$//
		T unitTest_failed_sumIntegers_simple
	z ; s/^/stack:unitTest_after_sumIntegers_overflow,/ ; h
	z ; s/^/1 15 10/
	b sumIntegers
	:unitTest_after_sumIntegers_overflow
		s/^overflow$//
		T unitTest_failed_sumIntegers_overflow
	z ; s/^/stack:unitTest_after_countHand,/ ; h
	z ; s/^/Ad 4s 5h/
	b countHand
	:unitTest_after_countHand
		s/^\s*20\s*$//
		T unitTest_failed_countHand
	z ; s/^/stack:unitTest_after_countPlayerHand,/ ; h
	z ; s/^/playerHand:Ad 4s 5h/ ; H
	z
	b countPlayerHand
	:unitTest_after_countPlayerHand
		s/^\s*20\s*$//
		T unitTest_failed_countPlayerHand
	z ; s/^/stack:unitTest_after_countDealerHand,/ ; h
	z ; s/^/dealerHand:Ad 4s 5h/ ; H
	z
	b countDealerHand
	:unitTest_after_countDealerHand
		s/^\s*20\s*$//
		T unitTest_failed_countDealerHand
	z ; s/^/stack:unitTest_after_endGameCompare_tie,/ ; h
	z ; s/^/dealerHand:Ad 4s 5h/ ; H
	z ; s/^/playerHand:6h Ad 3s/ ; H
	z ; s/^/unit-test:unit-test/ ; H
	z
	b endGameCompare
	:unitTest_after_endGameCompare_tie
		s/^.*OVER.*TIE//
		T unitTest_failed_endGameCompare_tie
	z ; s/^/stack:unitTest_after_endGameCompare_dealerWins,/ ; h
	z ; s/^/dealerHand:Ad 5s 5h/ ; H
	z ; s/^/playerHand:6h Ad 3s/ ; H
	z ; s/^/unit-test:unit-test/ ; H
	z
	b endGameCompare
	:unitTest_after_endGameCompare_dealerWins
		s/^.*OVER.*Dealer.*WON//
		T unitTest_failed_endGameCompare_dealerWins
	z ; s/^/stack:unitTest_after_endGameCompare_playerWins,/ ; h
	z ; s/^/dealerHand:6h Ad 3s/ ; H
	z ; s/^/playerHand:Ad 5s 5h/ ; H
	z ; s/^/unit-test:unit-test/ ; H
	z
	b endGameCompare
	:unitTest_after_endGameCompare_playerWins
		s/^.*OVER.*YOU.*WON//
		T unitTest_failed_endGameCompare_playerWins
	i OK: Self-tests passed!
	z ; h ; b
	:unitTest_failed_pickMinWeightWords
		i unitTest: pickMinWeightWords failed!
		b halt
	:unitTest_failed_pickRandomWord
		i unitTest: pickRandomWord failed!
		b halt
	:unitTest_failed_pushPattern
		i unitTest: pushPattern failed!
		b halt
	:unitTest_failed_popPattern
		i unitTest: popPattern failed!
		b halt
	:unitTest_failed_getRandom
		i unitTest: getRandom failed!
		b halt
	:unitTest_failed_attachRandomWeights
		i unitTest: attachRandomWeights failed!
		b halt
	:unitTest_failed_resetDeck
		i unitTest: resetDeck failed!
		b halt
	:unitTest_failed_dealCard
		i unitTest: dealCard failed!
		b halt
	:unitTest_failed_dealPlayerCard
		i unitTest: dealCard failed!
		b halt
	:unitTest_failed_dealDealerCard
		i unitTest: dealCard failed!
		b halt
	:unitTest_failed_displayHand
		i unitTest: displayHand failed!
		b halt
	:unitTest_failed_displayPlayerHand
		i unitTest: displayPlayerHand failed!
		b halt
	:unitTest_failed_displayDealerHand
		i unitTest: displayPlayerHand failed!
		b halt
	:unitTest_failed_sumIntegers_simple
		i unitTest: sumIntegers_simple failed!
		b halt
	:unitTest_failed_sumIntegers_overflow
		i unitTest: sumIntegers_overflow failed!
		b halt
	:unitTest_failed_countHand
		i unitTest: countHand failed!
		b halt
	:unitTest_failed_countPlayerHand
		i unitTest: countPlayerHand failed!
		b halt
	:unitTest_failed_countDealerHand
		i unitTest: countDealerHand failed!
		b halt
	:unitTest_failed_endGameCompare_tie
		i unitTest: endGameCompare_tie failed!
		b halt
	:unitTest_failed_endGameCompare_dealerWins
		i unitTest: endGameCompare_dealerWins failed!
		b halt
	:unitTest_failed_endGameCompare_playerWins
		i unitTest: endGameCompare_playerWins failed!
		b halt
# }}}

# {{{ stateDispatcher: proceed according to the program mode
# Mode is the first line in the hold space marked with state: tag.
# Jumps to command processor relevant to the corresponding mode.
:stateDispatcher
	x
	# It happens all the time that empty lines appear in the hold space
	# in sake of overall simplicity. For example s/^deck:.*$// command
	# removes any traces of the deck state, but leaves an empty line.
	# Clean it all up here.
	:stateDispatcher_clean
		s/\n\n+/\n/g
		t stateDispatcher_clean
	s/^\n+//
	s/\n+$//
	/^$/ {x ; b initStart }
	/^(.*\n)?state:game,/  {x ; b gameTurn }
	x
	i stateDispatcher: Unexpected state!
	b halt
# }}}

# {{{ main: CLI entry point
# Does not return, either jump to command processor or triggers self tests.
:main
	/^unit-test$/ b unitTest
	b stateDispatcher
# }}}

# vim: foldmethod=marker
