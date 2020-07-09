.include    "console.S"

.global      _start

_start:
    OUTSTRLN 	$outstrln_str	# passed the test

	OUTSTR		$outstr_str		# passed the test 

	NEWLINE						# passed the test
	NEWLINE		$5				# passed the test

    PAUSE
    PAUSE       $pause_str
    
    OUTSTR      $outstr_str
    FLUSH
    movl        $0, %eax
    call        _exit

	EXIT 			 			# passed the test

outstrln_str:
	.string "This is the OUTSTRLN output."

outstr_str:
	.string "This is the OUTSTR output."

pause_str:
    .string "This is the PAUSE output.\n"
