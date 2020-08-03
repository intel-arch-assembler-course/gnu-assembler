.include    "console.S"

.global      _start

_start:    

    INCHAR      %cl, $enter_letter_str
    OUTSTR      $you_entered_str
    OUTCHAR     %cl
    NEWLINE


    # Does not work!
    #

    #INCHAR      x, $enter_letter_str
    #OUTSTR      $you_entered_str
    #OUTCHAR     x
    #NEWLINE

    EXIT

enter_letter_str:
    .string "Enter some letter: "

you_entered_str:
    .string "You entered: "

x:
    .byte 0
