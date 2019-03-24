.ifndef __CONSOLE_MACROS_S__
.def    __CONFOLE_CACROS_S__
#
#
# This file contains macros definitions for working with
# console.
#
# These macroces has been written originally by 
# Vladimir Baula  specially for  
# "Computer Architecture and ASSEMBLER language" practicum.
#
#
# Addition there is a macros which terminates process, 
# by calling  exit() function.
#
# Macroces described in this file is designed only for
# x86 (i386) computer architecture.
#

.att_syntax

#
# constants and variables for macroces be
# working
#
    .text
CONSOLE_MACROS_OUTSTR_FMT_STR:
        .string "%s"

#
# Function for get eip register value
#
__x86.get_pc_thunk.bx:
        movl    (%esp), %ebx
        ret

#
# End constants and variables
#

######################################################
#
# OUTSTR -
# print string to stdout without newline 
# at end of string.
#
# Requires pointer to
# string in argument.
#
######################################################
.macro OUTSTR str_place:req
    .text                
        pushl   \str_place
        pushl   $CONSOLE_MACROS_OUTSTR_FMT_STR
        call    printf
        addl    $8, %esp
.endm

######################################################
# 
# OUTSTRLN -
# print string to stdout with newline 
# at end of string.
#
# Requires pointer to
# string in argument.
#
######################################################
.macro OUTSTRLN str_place:req
    .text                
        pushl   \str_place 
        call    puts
        addl    $4, %esp
.endm

#####################################################
#
# OUTCHAR - print one symbol
#           reqires one argument
#           one byte size 
#
####################################################
.macro OUTCHAR symb:req
    .text
        pushl   %ebx
        call    __x86.get_pc_thunk.bx
        addl    $_GLOBAL_OFFSET_TABLE_, %ebx
        movl    stdout@GOT(%ebx), %eax
        pushl   (%eax)
        movzx   \symb, %eax
        pushl   %eax
        call    fputc
        addl    $8, %esp
        popl    %ebx
.endm


#####################################################
# INPUTSTR - read string to 'buf' parabeter
#            where it can't overheade 'buf_size'
#            bytes.
#
#            buf_size must be 32 bit.
#
#            It return in eax zero if End of flow reached.                                                                     
#####################################################
.macro INPUTSTR buf:req buf_size=128
    .text
        pushl   %ebx
        call    __x86.get_pc_thunk.bx                                                                   
        addl    $_GLOBAL_OFFSET_TABLE_, %ebx
        
        movl    stdin@GOT(%ebx), %eax
        pushl   (%eax)
        pushl   \buf_size
        pushl   \buf
        call    fgets
        addl    $12, %esp
        popl    %ebx
.endm


.endif # for __CONSOLE_MACROS_H__ 

