.include    "console.S"

.global      _start

_start:    
    ININT16     %bx
    OUTINT      %bx
    EXIT
