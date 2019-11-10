.include    "console.S"

.global      _start

_start: 
    OUTSTR $str # macros OUTSTR passed the test
    EXIT # macros EXIT passed the test

str:
        .ascii "Hello, world!\12\0"
