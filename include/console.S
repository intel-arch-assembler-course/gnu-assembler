.ifndef __CONSOLE_MACROS_S__
.set    __CONSOLE_MACROS_S__,0
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

# 
# Save registers
#
.macro SAVE_REG F=$
    .text
        pushl    eax
        pushl    ecx
        pushl    edx

        .ifnb \F
            pushfd
        .endif
.endm


####################### 
#
# Restore registers
#
#######################
.macro RESTORE_REG F=$
    .text
        .ifnb \F
            popfd
        .endif

        popl    edx
        popl    ecx
        popl    eax
.endm

########################
# 
# Clear console screen
#
########################
.equ Cls, CLRSCR
.equ Cls, CLRSCR
.equ ClrScr, CLRSCR
#
.macro CLRSCR
    .text
        SAVE_REG      Flags
        call          ClearScreen # переделать
        RESTORE_REG   Flags

.endm

##################################
#
#  Move to a new line n times
#
##################################
.equ NewLine, NEWLINE
.equ Newline, NEWLINE
.equ newline, NEWLINE
##################################
.macro NEWLINE n=$1
    .text
        pushl   %ecx
        mov     \n, %ecx

    repeat_cycle:
        .if     %ecx
            OUTCHAR     13    
            OUTCHAR     10
            dec         %ecx
            jmp         repeat_cycle
        .endif

        popl     %ecx
.endm

###########################
#
# Exit from program
#
###########################
#
.equ Exit, EXIT
.equ exit, EXIT
#
###########################
.macro EXIT x=$0
    .text
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

####################################
#   READKEY txt=$ # al:=ord(char)
####################################
.equ ReadKey, READKEY
.equ readkey, READKEY
####################################
.macro READKEY txt=$
    .text
        .ifnb \txt
            OUTSTR  txt
        .endif
        
        pushl   ecx
        pushl   edx
        pushfd
        call    getc# al:=ord(char)
        popfd
        popl    edx
        popl    ecx
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

################################
#
# Pause and output txt
#
################################
.equ Pause, PAUSE
.equ pause, PAUSE

.macro PAUSE txt
    .text
        .ifnb   \txt
            OUTSTR  txt
        .endif
    
        SAVE_REG      Flags
        call          getchar # !!!ПРОВЕРИТЬ!!!
        RESTORE_REG   Flags
        NEWLINE
.endm

#####################################################
#
# INCHAR - read character from standard input
#          
#          it return in eax 0 if symb has been normaly
#          read and -1 on End of file and errors
#
####################################################
.macro INCHAR x:req, prompt: vararg
    .text
        .ifnb \prompt
            OUTSTR  prompt
        .endif

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

#################################
#
# Сброс буфера ввода
#
#################################
.equ Flush, FLUSH
.equ flush, FLUSH
#################################
.macro FLUSH
    .local buf, L

    .data
        buf db 0

    .text
            SAVE_REG      Flags
    L:      invoke        StdIn,offset buf,1 # one symbol
            cmp           buf,10
            jne           L
            RESTORE_REG   Flags
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

###########################################
# CF output (for OUTFLAGS)
###########################################
.equ OutCF, OUTCF
.equ outCF, OUTCF
.equ outcf, OUTCF
###########################################
.macro OUTCF
    .local Out_1_\@

    .text
        jnc         Out_1_\@
        OUTWORD     $0
Out_1_\@:
        OUTWORD     $1
.endm

###########################################
# OF output (for OUTFLAGS)
###########################################
.equ OutOF, OUTOF
.equ outOF, OUTOF
.equ outof, OUTOF
###########################################
.macro OUTOF
    .local Out_1_\@

    .text
        jo          Out_1_\@
        OUTWORD     $0
Out_1_\@:
        OUTWORD     $1
.endm

###########################################
# ZF output (for OUTFLAGS)
###########################################
.equ OutZF, OUTZF
.equ outZF, OUTZF
.equ outzf, OUTZF
###########################################
.macro OUTZF
    .local Out_1_\@

    .text
        jz          Out_1_\@
        OUTWORD     $0
Out_1_\@:
        OUTWORD     $1
.endm

###########################################
# SF output (for OUTFLAGS)
###########################################
.equ OutSF, OUTSF
.equ outSF, OUTSF
.equ outsf, OUTSF
###########################################
.macro OUTSF
    .local Out_1_\@

    .text
        js          Out_1_\@
        OUTWORD     $0
Out_1_\@:
        OUTWORD     $1
.endm

###########################################
# CF, OF, ZF, SF output
###########################################
.equ outflags, OUTFLAGS
.equ OutFlags, OUTFLAGS
###########################################
.macro OUTFLAGS
    .text
        OUTCF
        OUTOF
        OUTZF
        OUTSF
.endm

.endif # for __CONSOLE_MACROS_S__ 
