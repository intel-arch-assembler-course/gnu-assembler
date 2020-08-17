.include    "console.S"

.global      _start

_start:    
    ININT32     %ebx
    OUTINT      %ebx
    EXIT
