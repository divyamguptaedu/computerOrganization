;;=============================================================
;; CS 2110 - Fall 2022
;; Homework 5 - summation
;;=============================================================
;; Name: Divyam Gupta
;;=============================================================

;; Pseudocode (see PDF for explanation)
;;
;;    int result; (to save the summation of x)
;;    int x= -9; (given integer)
;;    int answer = 0;
;;    while (x > 0) {
;;        answer += x;
;;        x--;
;;    }
;;    result = answer;

.orig x3000
      AND R1, R1, #0        ;; Clearing R1
      LD R1, x              ;; R1 stores the value 'x'.
      AND R2, R2, #0        ;; Clearing R2
      AND R3, R3, #0        ;; Clearing R3, R3 = 0
      ADD R2, R2, R1        ;; R2 = x
W1    BRNZ DONE              ;; while (x > 0)
      ADD R3, R3, R2        ;; answer += x
      ADD R2, R2, #-1       ;; x--
      BRP W1
      BRNZ DONE
DONE  ST R3, result
      HALT

    x .fill -9
    result .blkw 1
.end
