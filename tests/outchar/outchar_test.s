.include    "console.S"

.global      _start

_start:    
    #OUTCHAR     $'a' # does not work because of "movzx %eax"
    
    movb        $'b', %al
    OUTCHAR     %al
    
    #OUTCHAR     $c # does not work because of "movzx %eax"
    
	EXIT 			 		

c:
	.byte 'c'

