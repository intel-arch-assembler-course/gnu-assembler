.include    "console.S"

.global      _start

_start:    
    OUTSTR      $outstr_str
    FLUSH
    movl        $0, %eax
    call        _exit

	EXIT 			 		

outstr_str:
	.string "This is the OUTSTR output."

