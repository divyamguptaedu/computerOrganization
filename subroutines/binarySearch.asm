;;=============================================================
;; CS 2110 - Fall 2021
;; Homework 6 - Binary Search
;;=============================================================
;; Name:
;;============================================================

;; In this file, you must implement the 'binarySearch' subroutine.

;; Little reminder from your friendly neighborhood 2110 TA staff: don't run
;; this directly by pressing 'RUN' in complx, since there is nothing put at
;; address x3000. Instead, load it and use 'Debug' -> 'Simulate
;; Subroutine Call' and choose the 'binarySearch' label.


;; Pseudocode:

;; Nodes are blocks of size 3 in memory:

;; The data is located in the 1st memory location
;; The node's left child address is located in the 2nd memory location
;; The node's right child address is located in the 3rd memory location

;; Binary Search

;;    binarySearch(Node root (addr), int data) {
;;        if (root == 0) {
;;            return 0;
;;        }
;;        if (data == root.data) {
;;            return root;
;;        }
;;        if (data < root.data) {
;;            return binarySearch(root.left, data);
;;        }
;;        return binarySearch(root.right, data);
;;    }

.orig x3000
    ;; you do not need to write anything here
HALT

binary_search
      ADD R6, R6, #-4 ;push 4 words
      STR R7, R6, #2  ;save old return address
      STR R5, R6, #1  ;save old frame pointer
      ADD R5, R6, #0  ;FP = SP
      ADD R6, R6, #-5 ;push 5 words
      STR R0, R5, #-1 ;save SR0
      STR R1, R5, #-2 ;save SR1
      STR R2, R5, #-3 ;save SR2
      STR R3, R5, #-4 ;save SR3
      STR R4, R5, #-5 ;save SR4

      LDR R1, R5, #4  ;R1 = root
      ADD R1, R1, #0  ;Set CC
      BRnp IF2        ;if (root != null)

      AND R0, R0, #0  ;R0 = 0
      STR R0, R5, #0  ;R5 = 0
      BR TEAR         ;return

IF2   LDR R0, R1, #0  ;R0 = root.data
      AND R2, R2, #0  ;clear R2
      LDR R2, R5, #5  ;R2 = data
      AND R3, R3, #0  ;clear R3
      ADD R3, R2, #0  ;R3 = data
      NOT R3, R3;     ;R3 = ~data
      ADD R3, R3, #1  ;R3 = -data
      ADD R3, R0, R3  ;R3 = root.data - data
      BRp IF3
      BRn FIN

      STR R1, R5, #0  ;R5 = root
      BR TEAR         ;return

IF3   AND R0, R0, #0  ;Clear R0
      ADD R0, R0, R2  ;R0 = data
      ADD R6, R6, #-1 ;SP++
      STR R0, R6, #0  ;push data

      LDR R0, R5, #4  ;R0 = root
      LDR R0, R0, #1  ;R0 = root.left
      ADD R6, R6, #-1 ;SP++
      STR R0, R6, #0  ;push root.left

      JSR binary_search
      LDR R0, R6, #0  ;pop the RV
      ADD R6, R6, #1  ;SP--;
      STR R0, R5, #0  ;R5 = answer
      ADD R6, R6, #2  ;pop 2 arguments
      BR TEAR

FIN   AND R0, R0, #0  ;Clear R0
      ADD R0, R0, R2  ;R0 = data
      ADD R6, R6, #-1 ;SP++
      STR R0, R6, #0  ;push data

      LDR R0, R5, #4  ;R0 = root
      LDR R0, R0, #2  ;R0 = root.right
      ADD R6, R6, #-1 ;SP++
      STR R0, R6, #0  ;push root.right

      JSR binary_search
      LDR R0, R6, #0  ;pop the RV
      ADD R6, R6, #1  ;SP--;
      STR R0, R5, #0  ;R5 = answer
      ADD R6, R6, #2  ;pop 2 arguments

TEAR  LDR R0, R5, #0  ;R0 = RET
      STR R0, R5, #3  ;Store RET in RV
      LDR R4, R5, #-5 ;Restore R4
      LDR R3, R5, #-4 ;Restore R3
      LDR R2, R5, #-3 ;Restore R2
      LDR R1, R5, #-2 ;Restore R1
      LDR R0, R5, #-1 ;Restore R0
      ADD R6, R5, #0  ;FP = SP
      LDR R5, R6, #1  ;R5 = Old FP
      LDR R7, R6, #2  ;R7 = Return Address
      ADD R6, R6, #3  ;Pop 3 words
      RET


STACK .fill xF000
.end

;; Assuming the tree starts at address x4000, here's how the tree (see below and in the pdf) represents in memory
;;
;;              4
;;            /   \
;;           2     8
;;         /   \
;;        1     3
;;
;; Memory address           Data
;; x4000                    4
;; x4001                    x4004
;; x4002                    x4008
;; x4003                    Don't Know
;; x4004                    2
;; x4005                    x400C
;; x4006                    x4010
;; x4007                    Don't Know
;; x4008                    8
;; x4009                    0(NULL)
;; x400A                    0(NULL)
;; x400B                    Don't Know
;; x400C                    1
;; x400D                    0(NULL)
;; x400E                    0(NULL)
;; x400F                    Dont't Know
;; x4010                    3
;; x4011                    0(NULL)
;; x4012                    0(NULL)
;; x4013                    Dont't Know
;;
;; *note: 0 is equivalent to NULL in assembly
