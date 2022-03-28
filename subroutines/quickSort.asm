;;=============================================================
;; CS 2110 - Fall 2021
;; Homework 6 - Quick Sort
;;=============================================================
;; Name:
;;============================================================

;; In this file, you must implement the 'quicksort' and 'partition' subroutines.

;; Little reminder from your friendly neighborhood 2110 TA staff: don't run
;; this directly by pressing 'RUN' in complx, since there is nothing put at
;; address x3000. Instead, load it and use 'Debug' -> 'Simulate
;; Subroutine Call' and choose the 'quicksort' or 'partition' label.


;; Pseudocode:

;; Partition

;;    partition(int[] arr, int low, int high) {
;;        int pivot = arr[high];
;;        int i = low - 1;
;;        for (j = low; j < high; j++) {
;;            if (arr[j] < pivot) {
;;                i++;
;;                int temp = arr[j];
;;                arr[j] = arr[i];
;;                arr[i] = temp;
;;            }
;;        }
;;        int temp = arr[high];
;;        arr[high] = arr[i + 1];
;;        arr[i + 1] = temp;
;;        return i + 1;
;;    }

;; Quicksort

;;    quicksort(int[] arr, int left, int right) {
;;        if (left < right) {
;;            int pi = partition(arr, left, right);
;;            quicksort(arr, left, pi - 1);
;;            quicksort(arr, pi + 1, right);
;;        }
;;    }


.orig x3000
    ;; you do not need to write anything here
HALT

partition
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

      LDR R0, R5, #4  ;R0 = arr.address
      LDR R1, R5, #6  ;R1 = high
      ADD R0, R0, R1  ;R0 = arr.address + high
      LDR R0, R0, #0  ;R0 = arr.high; pivot
      STR R0, R5, #0  ;LV1 = pivot
      AND R0, R0, #0  ;Clear R0
      LDR R0, R5, #5  ;R0 = low
      AND R1, R1, #0  ;Clear R1
      ADD R1, R0, #0  ;R1 = low; j = low
      ADD R0, R0, #-1 ;R0 = low - 1; i = low - 1

FOR   LDR R2, R5, #6  ;R2 = high
      NOT R2, R2      ;R2 = ~high
      ADD R2, R2, #1  ;R2 = -high
      ADD R2, R1, R2  ;R2 = low - high
      BRn IF          ;high > low

      LDR R2, R5, #4  ;R2 = arr
      AND R3, R3, #0  ;Clear R3
      ADD R3, R0, #1  ;R3 = i+1
      ADD R2, R2, R3  ;R2 = arr.address + i+1
      LDR R3, R2, #0  ;R3 = arr[i+1]
      LDR R2, R5, #4  ;R2 = arr
      LDR R4, R5, #6  ;R4 = high
      ADD R2, R2, R4  ;R2 = arr.address + high
      STR R3, R2, #0  ;arr.high = arr(i+1)
      LDR R2, R5, #4  ;R2 = arr
      LDR R4, R5, #0  ;R4 = pivot
      AND R3, R3, #0  ;Clear R3
      ADD R3, R0, #1  ;R3 = i+1
      ADD R2, R2, R3  ;R2 = arr.address + i+1
      STR R4, R2, #0  ;arr.i+1 = pivot
      LDR R2, R5, #4  ;R2 = arr
      STR R3, R5, #0  ;LV1 = i+1
      BR TEAR

IF    LDR R3, R5, #4  ;R3 = arr
      ADD R3, R3, R1  ;R3 = arr.address + j
      LDR R3, R3, #0  ;R3 = arr.j
      NOT R3, R3      ;R3 = ~arr.j
      ADD R3, R3, #1  ;R3 = -arr.j
      LDR R4, R5, #0  ;R4 = pivot
      ADD R4, R4, R3  ;R4 = pivot - arr.j
      BRp COND
      ADD R1, R1, #1  ;j++
      BR FOR

COND  ADD R0, R0, #1  ;i++
      NOT R3, R3      ;R3 = ~(-arr.j)
      ADD R3, R3, #1  ;R3 = arr.j
      AND R4, R4, #0  ;Clear R4
      ADD R4, R3, #0  ;R4 (temp) = arr.j
      LDR R2, R5, #4  ;R2 = arr
      ADD R2, R2, R0  ;R2 = arr.address + i
      LDR R3, R2, #0  ;R3 = arr.i
      LDR R2, R5, #4  ;R2 = arr
      ADD R2, R2, R1  ;R2 = arr.address + j
      STR R3, R2, #0  ;arr.j = arr.i
      LDR R2, R5, #4  ;R2 = arr
      ADD R2, R2, R0  ;R2 = arr.address + i
      STR R4, R2, #0  ;arr.i = temp
      LDR R2, R5, #4  ;R2 = arr
      ADD R1, R1, #1  ;j++
      BR FOR

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

quicksort
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

      LDR R0, R5, #5  ;R0 = left
      LDR R1, R5, #6  ;R1 = right
      AND R2, R2, #0  ;Clear R3
      ADD R2, R1, #0  ;R2 = right
      NOT R2, R2      ;R2 = ~right
      ADD R2, R2, #1  ;R2 = -right
      ADD R2, R0, R2  ;R2 = left - right
      BRn CONT
      BR TEAR2

CONT  ADD R6, R6, #-1 ;SP++
      STR R1, R6, #0  ;push right
      ADD R6, R6, #-1 ;SP++
      STR R0, R6, #0  ;push left
      LDR R2, R5, #4  ;R2 = arr
      ADD R6, R6, #-1 ;SP++
      STR R2, R6, #0  ;push arr
      JSR partition   ;
      LDR R3, R6, #0  ;R3 = pi
      ADD R6, R6, #1  ;SP--;
      ADD R6, R6, #3  ;pop 3 arguments
      AND R4, R4, #0  ;Clear R4
      ADD R4, R3, #-1  ;R4 = pi - 1
      ADD R6, R6, #-1 ;SP++
      STR R4, R6, #0  ;push pi - 1
      ADD R6, R6, #-1 ;SP++
      STR R0, R6, #0  ;push left
      ADD R6, R6, #-1 ;SP++
      STR R2, R6, #0  ;push arr
      JSR quicksort   ;
      ADD R6, R6, #1  ;SP--;
      ADD R6, R6, #3  ;pop 3 arguments
      ADD R6, R6, #-1 ;SP++
      STR R1, R6, #0  ;push right
      ADD R4, R4, #2  ;R4 = pi + 1
      ADD R6, R6, #-1 ;SP++
      STR R4, R6, #0  ;push pi - 1
      ADD R6, R6, #-1 ;SP++
      STR R2, R6, #0  ;push arr
      JSR quicksort   ;
      ADD R6, R6, #1  ;SP--;
      ADD R6, R6, #3  ;pop 3 arguments

TEAR2 LDR R0, R5, #0  ;R0 = RET
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


;; Assuming the array starts at address x4000, here's how the array [1,3,2,5] represents in memory
;; Memory address           Data
;; x4000                    1
;; x4001                    3
;; x4002                    2
;; x4003                    5
