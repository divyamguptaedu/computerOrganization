;;=============================================================
;; CS 2110 - Fall 2022
;; Homework 5 - binaryStringToInt
;;=============================================================
;; Name: Divyam Gupta
;;=============================================================

;; Pseudocode (see PDF for explanation)
;;
;;    int result = x4000; (given memory address to save the converted value)
;;    String binaryString= "01000000"; (given binary string)
;;    int length = 8; (given length of the above binary string)
;;    int base = 1;
;;    int value = 0;
;;    while (length > 0) {
;;        int y = binaryString.charAt(length - 1) - 48;
;;        if (y == 1) {
;;            value += base;
;;        }
;;            base += base;
;;            length--;
;;    }
;;    mem[result] = value;


.orig x3000
        AND R2, R2, #0      ;; Clearing R2
        ADD R2, R2, #1      ;; int base = 1;
        AND R3, R3, #0      ;; Clearing R3
        ADD R3, R3, #0      ;; int value = 0;
        LD R1, length       ;; R1 = binaryString.Length
        BRNZ DONE
        BRP W1              ;; while (length > 0)
W1      LD R4, binaryString
        AND R5, R5, #0
        ADD R5, R5, R1
        ADD R5, R5, #-1
			  ADD R4, R4, R5
			  LDR R4, R4, #0		  ;; R4 = binaryString[length - 1]
        ADD R4, R4, #-12
        ADD R4, R4, #-12
        ADD R4, R4, #-12
        ADD R4, R4, #-12    ;; int y = binaryString.charAt(length - 1) - 48
        AND R5, R5, #0      ;; clearing R5
        ADD R5, R5, #-1     ;; R5 = -1
        AND R6, R6, #0      ;; clearing R6
        ADD R6, R4, R5      ;; R6 = y - 1
        BRZ ONE
        BR CONT
ONE     ADD R3, R3, R2      ;; value += base
CONT    ADD R2, R2, R2      ;; base += base
        ADD R1, R1, #-1     ;; length--
        BRP W1
        BR DONE
DONE    STI R3, result       ;; after while loop



    ;; YOUR CODE HERE
    HALT

    binaryString .fill x5000
    length .fill 8
    result .fill x4000
.end

.orig x5000
    .stringz "01000000"
.end
