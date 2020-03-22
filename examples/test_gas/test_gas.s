.include    "console.S"

.global      _start

_start:

	OUTNUM	num

	EXIT 			 # passed the test

num:
	.word 1
