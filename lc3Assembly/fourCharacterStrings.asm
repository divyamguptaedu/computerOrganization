;;=============================================================
;; CS 2110 - Fall 2022
;; Homework 5 - fourCharacterStrings
;;=============================================================
;; Name:
;;=============================================================


;; Pseudocode (see PDF for explanation)
;;
;; int count = 0;
;; int chars = 0;
;; int i = 0;
;;
;;  while(str[i] != '\0') {
;;      if (str[i] != ' ')
;;          chars++;
;;
;;      else {
;;          if (chars == 4)
;;              count++;
;;          chars = 0;
;;      }
;;      i++;
;;  }
;; ***IMPORTANT***
;; - Assume that all strings provided will end with a space (' ').
;; - Special characters do not have to be treated differently. For instance, strings like "it's" and "But," are considered 4 character strings.
;;

.orig x3000
					AND 	R1, R1, #0      ;; Clearing R1, int count = 0
					AND 	R2, R2, #0			;; Clearing R2, int chars = 0
					AND 	R3, R3, #0			;; Clearing R3, int i = 0
					LD  	R4, STRING			;; R4 = x4000
					LDR 	R4, R4, #0
					BRZ 	END
W1				ADD 	R4, R4, #-16
					ADD 	R4, R4, #-16
					BRP 	IF
					BRZ 	ELSE
IF				ADD 	R2, R2, #1
					BR CONT
ELSE			AND 	R5, R5, #0			;; Clearing R5
					ADD 	R5, R2, #-4			;; R5 = char - 4
					BRZ 	IF2
					BRNP 	ELSE2
IF2				ADD 	R1, R1, #1
ELSE2			AND 	R2, R2, #0
CONT			ADD 	R3, R3, #1
					LD R4, STRING
					ADD R4, R4, R3
					LDR R4, R4, #0
					BRNP W1
					BRZ END
END  			ST R1, ANSWER


	HALT


SPACE 	.fill #-32
STRING	.fill x4000
ANSWER .blkw 1

.end


.orig x4000
.stringz "I love CS 2110 and assembly is very fun! "

.end
