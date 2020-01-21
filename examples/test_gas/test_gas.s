.intel_syntax noprefix

.include "console.S"

.global _start

    .text
    .global PRINTING_TEXT
PRINTING_TEXT:
    .string "la la\n"

.text
_start:
    lea eax, PRINTING_TEXT
    OUTSTR   "offset PRINTING_TEXT"
    EXIT_PRG eax
