.include    "console.S"

.global      _start

_start:    
    INWORD8     %bl
    OUTINT      %bl
    EXIT
