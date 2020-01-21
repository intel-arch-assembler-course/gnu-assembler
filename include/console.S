.ifndef .LCONSOLE_MACROS_S__
.set    .LCONSOLE_MACROS_S__,0
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

.intel_syntax noprefix

#
# constants and variables for macroces be
# working
#
    .text
.global CONSOLE_MACROS_OUTSTR_FMT_STR
CONSOLE_MACROS_OUTSTR_FMT_STR:
        .string "%s"

.global CONSOLE_MACROS_INT_FMT_STR
CONSOLE_MACROS_INT_FMT_STR:
        .string "%d"

.global CONSOLE_MACROS_UNSIGNED_FMT
CONSOLE_MACROS_UNSIGNED_FMT:
        .string "%u"

.global CONSOLE_MACROS_EMPTY_STR
CONSOLE_MACROS_EMPTY_STR:
        .string ""

    .text

#
# Function for get eip register value
#
__save_eip_in_ebx:
        mov    ebx,    [esp]
        ret

#
# End constants and variables
#

#**************************
# Выход из программы (переписанный)
#**************************
.equ Exit_PRG, EXIT_PRG
.equ exit_prg, EXIT_PRG
#**********************
.macro EXIT_PRG exit_code=0
    
    .text
        mov     eax, \exit_code
        push    eax
        call    exit
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
/*
    .ifnc        eax,\str_place
    .else
        .ifnc  ebx,\str_place
        .else .ifnc  ecx,\str_place
    .else .ifnc  edx,\str_place
    .else .ifnc  esi,\str_place
    .else .ifnc  edi,\str_place
    .else .ifnc  ebp,\str_place
    .else .ifnc  esp,\str_place
*/
    //    push    \str_place
    //.else
        push    \str_place
    //.endif .endif .endif .endif .endif .endif .endif .endif
        push    offset CONSOLE_MACROS_OUTSTR_FMT_STR
        push    eax
        call    printf
        add     esp,    8
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
.macro OUTSTRLN str_place= "offset CONSOLE_MACROS_EMPTY_STR"
    .text
        push   \str_place
        call    puts
        add    esp, 4
.endm
.endif # for __CONSOLE_MACROS_S__ 

