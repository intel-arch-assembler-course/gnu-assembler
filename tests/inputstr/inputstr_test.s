.include    "console.S"

.global      _start

_start: 
    # Tests does not work: segmentation fault.

    #INPUTSTR       %eax
    #OUTSTR          %eax

    #INPUTSTR        $buf
    #OUTSTR          $buf

    EXIT		 		


    .bss
buf:
    .skip 128
