.include    "console.S"

.global      _start

_start:    
    INWORD16    %bx
    OUTINT      %bx
    EXIT
