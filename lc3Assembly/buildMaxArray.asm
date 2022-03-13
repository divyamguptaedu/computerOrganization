;;=============================================================
;; CS 2110 - Fall 2022
;; Homework 5 - buildMaxArray
;;=============================================================
;; Name: Divyam Gupta
;;=============================================================


;; Pseudocode (see PDF for explanation)
;;
;;	int A[] = {1,2,3};
;;	int B[] = {-1, 7, 8};
;;	int C[3];
;;
;;	int i = 0;
;;
;;	while (i < A.length) {
;;		if (A[i] < B[i])
;;			C[i] = B[i];
;;		else
;;			C[i] = A[i];
;;
;;		i += 1;
;;	}


.orig x3000
			AND R2, R2, #0        ;; Clearing R2
			LD R2, LEN            ;; R2 stores the length. R2 = A.length
			AND R1, R1, #0        ;; Clearing R1, int i = 0
W1 		LD R3, A
			ADD R3, R3, R1
			LDR R3, R3, #0				;; R3 = A[i]
			LD R4, B
			ADD R4, R4, R1
			LDR R4, R4, #0				;; R4 = B[i]
			NOT R4, R4
			ADD R4, R4, #1				;; R4 = -B[i]
			AND R5, R5, #0				;; Clearing R5
			ADD R5, R3, R4				;; R5 = R3 - R4
			BRN IF
			BRZP ELSE
IF		LD R6, C
			ADD R6, R6, R1
			NOT R4, R4
			ADD R4, R4, #1
			STR R4, R6, #0
			BR CONT
ELSE
			LD R6, C
			ADD R6, R6, R1
			STR R3, R6, #0
CONT
			ADD R1, R1, #1				;; i++
			AND R5, R5, #0				;; Clearing R5
			AND R6, R6, #0				;; Clearing R6
			NOT R6, R1
			ADD R6, R6, #1				;; R6 = -i
			ADD R5, R2, R6				;; R5 = A.length - i
			BRP W1
	HALT


A 	.fill x3200
B 	.fill x3300
C 	.fill x3400
LEN .fill 4

.end

.orig x3200
	.fill -1
	.fill 2
	.fill 7
	.fill -3
.end

.orig x3300
	.fill 3
	.fill 6
	.fill 0
	.fill 5
.end

.orig x3400
.blkw 4
.end
