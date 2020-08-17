.include    "console.S"

.global      _start

_start:    
    ININT8      %bl
    OUTINT      %bl
    EXIT
