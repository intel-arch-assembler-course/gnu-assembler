.ifndef __CONSOLE_MACROS_S__
.def    __CONSOLE_MACROS_S__
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
CONSOLE_MACROS_INT_FMT_STR:
        .string "%d"
CONSOLE_MACROS_UNSIGNED_FMT:
        .string "%u"
CONSOLE_MACROS_EMPTY_STR:
        .string ""

#
# Function for get eip register value
#
__save_eip_in_ebx:
        movl    (%esp), %ebx
        ret

#
# End constants and variables
#

#**************************
# Выход из программы (переписанный)
#**************************
.equ Exit, EXIT
.equ exit, EXIT
#**********************
.macro EXIT x=$0
    mov     $60, %eax               # system call 60 is exit
    movl    \x, %edi
    shr     $1, %edi
    syscall 
.endm

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
.macro OUTSTRLN str_place=$CONSOLE_MACROS_EMPTY_STR
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
        call    __save_eip_in_ebx
        addl    $_GLOBAL_OFFSET_TABLE_, %ebx
        movl    stdout@GOT(%ebx), %eax
        pushl   (%eax)
        movzx   \symb, %eax
        pushl   %eax
        call    fputc
        addl    $8, %esp
        popl    %ebx
.endm

##################################################
#
# OUTNUM - write various number types.
#          tip= {d,u} d - signed, u-unsigned 
#
#################################################
.macro OUTNUM x:req tip=d
    .text
        pushl   %ebx
        call    __save_eip_in_ebx                                                                   
        addl    $_GLOBAL_OFFSET_TABLE_, %ebx
       
        pushl  \x
        .ifc \tip, d
            pushl   $CONSOLE_MACROS_INT_FMT_STR
        .elseif  \tip, u
            pushl   $CONSOLE_MACROS_UNSIGNED_FMT_STR
        .else
            .err "Unknown mode"
        .endif
        movl    stdin@GOT(%ebx), %eax
        pushl   (%eax)
        call    fprintf
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
        call    __save_eip_in_ebx                                                                   
        addl    $_GLOBAL_OFFSET_TABLE_, %ebx
        
        movl    stdin@GOT(%ebx), %eax
        pushl   (%eax)
        pushl   \buf_size
        pushl   \buf
        call    fgets
        addl    $12, %esp
        popl    %ebx
.endm


#####################################################
#
# INCHAR - read character from standard input
#          
#          it return in eax 0 if symb has been normaly
#          read and -1 on End of file and errors
#
####################################################
.macro INCHAR x:req
    .text
        pushl   %ebx
        call    __save_eip_in_ebx
        addl    $_GLOBAL_OFFSET_TABLE_, %ebx

        movl    stdin@GOT(%ebx), %eax
        pushl   (%eax)
        call    fgetc
        addl    $4, %esp
        popl    %ebx
        
        cmpl   %eax, $0
        jle    INCHAR_gen_err_exit_\@
        movb   %al, \x
        movl   $0,   %eax
        jmp    INCHAR_FIN_\@
        
INCHAR_gen_err_exit_\@:
       mov    $-1, %eax

INCHAR_FIN_\@:
.endm

##################################################
#
# ININT - read signed number from stdin.
#         read only 32 bit integer
#
#################################################
.macro ININT x:req
    .text
        pushl   %ebx
        call    __save_eip_in_ebx                                                                   
        addl    $_GLOBAL_OFFSET_TABLE_, %ebx
        
        pushl   %ebp
        movl    %esp, %ebp
        subl    $4,   %esp
 
        leal    -4(%ebp), %eax
        pushl   %eax
        pushl   $CONSOLE_MACROS_INT_FMT_STR
        movl    stdin@GOT(%ebx), %eax
        pushl   (%eax)
        call    fscanf

#TODO check return value
        movl    -4(%ebp), \x  

        movl    %ebp, %esp
        popl    %ebp
        popl    %ebx
.endm
        
##################################################
#
# INWORD - read signed number from stdin.
#         read only 32 bit integer
#
#################################################
.macro INWORD x:req
    .text
        pushl   %ebx
        call    __save_eip_in_ebx                                                                   
        addl    $_GLOBAL_OFFSET_TABLE_, %ebx
        
        pushl    %ebp
        movl    %esp, %ebp
        subl    $4,   %esp
 
        leal    -4(%ebp), %eax
        pushl   %eax
        pushl   $CONSOLE_MACROS_UNSIGNED_FMT_STR
        movl    stdin@GOT(%ebx), %eax
        pushl   (%eax)
        call    fscanf

#TODO check return value
        movl    -4(%ebp), \x
        
        movl    %ebp, %esp
        popl    %ebp
        popl    %ebx
.endm



.endef # for __CONSOLE_MACROS_S__ 

