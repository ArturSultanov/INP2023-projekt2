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
; Bubble sort implementation
bubble_sort:
    daddi   r4, r0, login      ; Load the base address of the string into r4
    move    r5, r4             ; Copy the base address to r5 (will be used to find the end of the string)
    daddi   r6, r0, 1          ; Initialize r6 with 1 (used for indexing through the string)

find_length:
    lb      r7, 0(r5)          ; Load the byte at the current position into r7
    beqz    r7, start_sort     ; If the byte is zero (end of the string), start sorting
    daddi   r5, r5, 1          ; Move to the next position in the string
    daddi   r6, r6, 1          ; Increment the index
    j       find_length

start_sort:
    daddi   r6, r6, -1         ; Decrement r6 to get the actual string length
    move    r8, r6             ; Copy the length to r8, which will be used for the outer loop

outer_loop:
    daddi   r9, r0, 1          ; Initialize r9 with 1, which will be used for the inner loop
    move    r10, r4            ; Copy the base address to r10

inner_loop:
    lb      r11, 0(r10)        ; Load the current byte into r11
    lb      r12, 1(r10)        ; Load the next byte into r12
    bge     r11, r12, no_swap  ; If the current byte is greater than or equal to the next byte, no need to swap

    ; Swap the bytes
    sb      r12, 0(r10)        ; Store the next byte at the current position
    sb      r11, 1(r10)        ; Store the current byte at the next position

no_swap:
    daddi   r9, r9, 1          ; Increment the inner loop index
    daddi   r10, r10, 1        ; Move to the next position in the string
    blt     r9, r8, inner_loop ; If the inner loop index is less than the length, continue the inner loop

    daddi   r8, r8, -1         ; Decrement the outer loop index
    bgtz    r8, outer_loop     ; If the outer loop index is greater than zero, continue the outer loop

    jr      r31                ; Return

    jal     bubble_sort

    daddi   r4, r0, login   ; vozrovy vypis: adresa login: do r4
    jal     print_string    ; vypis pomoci print_string - viz nize

    syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
