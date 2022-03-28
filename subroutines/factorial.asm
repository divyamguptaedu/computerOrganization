;;=============================================================
;; CS 2110 - Fall 2021
;; Homework 6 - Factorial
;;=============================================================
;; Name:
;;============================================================

;; In this file, you must implement the 'factorial' and "mult" subroutines.

;; Little reminder from your friendly neighborhood 2110 TA staff: don't run
;; this directly by pressing 'RUN' in complx, since there is nothing put at
;; address x3000. Instead, load it and use 'Debug' -> 'Simulate
;; Subroutine Call' and choose the 'factorial' or 'mult' label.

;; Pseudocode

;; Factorial

;;    factorial(int n) {
;;        int ret = 1;
;;        for (int x = 2; x < n+1; x++) {
;;            ret = mult(ret, x);
;;        }
;;        return ret;
;;    }

;; Multiply

;;    mult(int a, int b) {
;;        int ret = 0;
;;        int copyB = b;
;;        while (copyB > 0):
;;            ret += a;
;;            copyB--;
;;        return ret;
;;    }


.orig x3000
    ;; you do not need to write anything here
HALT

factorial
      ADD R6, R6, #-4 ;push 4 words
      STR R7, R6, #2  ;save old return address
      STR R5, R6, #1  ;save old frame pointer
      ADD R5, R6, #0  ;FP = SP
      ADD R6, R5, #-6 ;push 6 words
      STR R0, R5, #-2 ;save SR1
      STR R1, R5, #-3 ;save SR2
      STR R2, R5, #-4 ;save SR3
      STR R3, R5, #-5 ;save SR4
      STR R4, R5, #-6 ;save SR5

      AND R0, R0, #0  ;clear R0
      ADD R0, R0, #1  ;R0   = ret = 1
      STR R0, R5, #0  ;LV1  = ret = 1

      AND R0, R0, #0  ;clear R0
      ADD R0, R0, #2  ;R0   = x = 2
      STR R0, R5, #-1 ;LV2  = x = 2

FOR   LDR R0, R5, #-1 ;R0 = x
      LDR R1, R5, #4  ;R1 = n
      ADD R1, R1, #1  ;n+1
      NOT R1, R1;     ;R1 = ~(n+1)
      ADD R1, R1, #1  ;R1 = -(n+1)
      ADD R0, R1, R0  ;R0 = x-(n+1)
      BRzp ENDF       ;x >= n + 1

      LDR R0, R5, #-1 ;R0 = x
      ADD R6, R6, #-1 ;SP++
      STR R0, R6, #0  ;push x

      LDR R0, R5, #0  ;R0 = ret
      ADD R6, R6, #-1 ;SP++
      STR R0, R6, #0  ;push ret

      JSR mult        ;mult(ret, x)
      LDR R0, R6, #0  ;pop the RV
      ADD R6, R6, #1  ;SP--;
      STR R0, R5, #0  ;ret = mult(ret, x)
      ADD R6, R6, #2  ;pop 2 arguments

      LDR R0, R5, #-1 ;R0 = x
      ADD R0, R0, #1  ;x++
      STR R0, R5, #-1 ;LV2 = x
      BR FOR

ENDF  LDR R0, R5, #0  ;R0 = RET
      STR R0, R5, #3  ;Store RET in RV
      LDR R4, R5, #-6 ;Restore R4
      LDR R3, R5, #-5 ;Restore R3
      LDR R2, R5, #-4 ;Restore R2
      LDR R1, R5, #-3 ;Restore R1
      LDR R0, R5, #-2 ;Restore R0
      ADD R6, R5, #0  ;FP = SP
      LDR R7, R5, #2  ;R7 = Return Address
      LDR R5, R5, #1  ;R5 = Old FP
      ADD R6, R6, #3  ;Pop 3 words
      RET

mult
      ADD R6, R6, #-4 ;push 4 words
      STR R7, R6, #2  ;save old return address
      STR R5, R6, #1  ;save old frame pointer
      ADD R5, R6, #0  ;FP = SP
      ADD R6, R5, #-6 ;push 6 words
      STR R0, R5, #-2 ;save SR1
      STR R1, R5, #-3 ;save SR2
      STR R2, R5, #-4 ;save SR3
      STR R3, R5, #-5 ;save SR4
      STR R4, R5, #-6 ;save SR5

      AND R0, R0, #0  ;R0   = ret
      STR R0, R5, #0  ;LV1  = ret   = 0

      LDR R0, R5, #5  ;R0   = copyB = b
      STR R0, R5, #-1 ;LV2  = copyB = b

WHILE ADD R0, R0, #0  ;set CC
      BRnz ENDW

      LDR R0, R5, #0  ;R0   = ret
      LDR R1, R5, #4  ;R1   = a
      ADD R0, R0, R1  ;ret  = ret + a
      STR R0, R5, #0  ;LV1  = ret

      LDR R0, R5, #-1  ;R0   = copyB
      ADD R0, R0, #-1 ;copyB--;
      STR R0, R5, #-1 ;LV2  = copyB

      BR WHILE

ENDW  LDR R0, R5, #0  ;R0 = RET
      STR R0, R5, #3  ;Store RET in RV
      LDR R4, R5, #-6 ;Restore R4
      LDR R3, R5, #-5 ;Restore R3
      LDR R2, R5, #-4 ;Restore R2
      LDR R1, R5, #-3 ;Restore R1
      LDR R0, R5, #-2 ;Restore R0
      ADD R6, R5, #0  ;FP = SP
      LDR R7, R5, #2  ;R7 = Return Address
      LDR R5, R5, #1  ;R5 = Old FP
      ADD R6, R6, #3  ;Pop 3 words
      RET

STACK .fill xF000
.end
