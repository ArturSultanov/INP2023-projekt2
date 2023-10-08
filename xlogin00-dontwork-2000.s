; Autor reseni: Jmeno Prijmeni login
; Pocet cyklu k serazeni puvodniho retezce:
; Pocet cyklu razeni sestupne serazeneho retezce:
; Pocet cyklu razeni vzestupne serazeneho retezce:
; Pocet cyklu razeni retezce s vasim loginem:
; Implementovany radici algoritmus:
; ------------------------------------------------

; DATA SEGMENT
                .data
login:          .asciiz "vitejte-v-inp-2023"    ; puvodni uvitaci retezec
; login:          .asciiz "vvttpnjiiee3220---"  ; sestupne serazeny retezec
; login:          .asciiz "---0223eeiijnpttvv"  ; vzestupne serazeny retezec
; login:          .asciiz "xlogin00"            ; SEM DOPLNTE VLASTNI LOGIN
                                                ; A POUZE S TIMTO ODEVZDEJTE

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize - "funkce" print_string)

; CODE SEGMENT
                .text
main:
        ; Initialize pointers and counters
        daddi   r1, r0, login   ; r1 = pointer to the start of the string

outer_loop:
        daddi   r9, r1, 0       ; r9 = pointer for outer loop

inner_loop:
        lb      r3, 0(r9)       ; r3 = current character
        lb      r4, 1(r9)       ; r4 = next character

        ; If end of string, end inner loop
        beq     r4, r0, end_inner 

        ; If current character > next character, swap them
        slt     r5, r4, r3      ; set r5 = 1 if r4 < r3 (means r3 > r4)
        beq     r5, r0, skip_swap

swap:
        sb      r3, 1(r9)       ; store value of r3 to [r9+1]
        sb      r4, 0(r9)       ; store value of r4 to [r9]

skip_swap:
        daddi   r9, r9, 1       ; move r9 to the next character
        j       inner_loop

end_inner:
        daddi   r1, r1, 1       ; move r1 to the next character
        lb      r7, 0(r1)       ; load character at r1 to r7
        beq     r7, r0, end_outer ; if end of string, end outer loop
        j       outer_loop

end_outer:
        daddi   r4, r0, login   ; set r4 to the start of the string
        jal     print_string    ; call the print_string function

        syscall 0   ; halt


print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
