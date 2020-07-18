.include    "console.S"

.global      _start

_start: 
    OUTNUM  $1      # passed the test
    
    #movb    $2, %al    # doesn't work because of "pushl \x" instruction    
    #OUTNUM  %al        # in OUTNUM macros
    
    #movw    $3, %ax    # doesn't work because of "pushl \x" instruction
    #OUTNUM  %ax        # in OUTNUM macros
    
    movl    $4, %eax
    OUTNUM  %eax        # passed the test
       
    EXIT

