.include    "console.S"

.global      _start

_start:    
    OUTCHAR     $'a'
    
    movb        $100, %al
    OUTCHAR     %al
    
    OUTCHAR     $c
    
	EXIT 			 		

c:
	.byte 'c'

