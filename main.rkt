;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; --------------- 1 Letter Input and Memory Management ---------------

(define words
  '("APRICOT" "CRANBERRY" "ALMOND" "PINEAPPLE" "PEANUT" "STRAWBERRY-TREE" "ARTICHOKE" "ASPARAGUS" 
              "EGGPLANT" "AVOCADO" "BERGAMOT" "BAMBOO" "BANANA" "BASIL" "BEETROOT" "BROCCOLI" 
              "COCOA" "CARROT" "CRANBERRY" "CINNAMON" "STARFRUIT" "BLACKCURRANT" "CELERY" "CHERVIL" 
              "CHERRY" "CHESTNUT" "CHICORY" "CABBAGE" "CHIVES" "LEMON" "PUMPKIN" "CLEMENTINE" 
              "QUINCE" "CUCUMBER" "GHERKIN" "ZUCCHINI" "SQUASH" "WATERCRESS" "TURMERIC" "DATE" 
              "SHALLOT" "ENDIVE" "SPINACH" "FENNEL" "FENUGREEK" "BROAD-BEAN" "FIG" "STRAWBERRY" 
              "RASPBERRY" "FLAGEOLET-BEAN" "GINGER" "GUAVA" "POMEGRANATE" "SOUR-CHERRY" "GOOSEBERRY" "MARSHMALLOW" 
              "BEAN" "YAM" "JUJUBE" "PERSIMMON" "KIWI" "KUMQUAT" "LETTUCE" "LENTIL" 
              "LYCHEE" "CORN" "MANDARIN" "MANGO" "CASSAVA" "CHESTNUT" "MELON" "BLACKBERRY" 
              "BLUEBERRY" "TURNIP" "MEDLAR" "HAZELNUT" "WALNUT" "ONION" "OLIVE" "ORANGE" 
              "GRAPEFRUIT" "PAPAYA" "WATERMELON" "POTATO" "PATTYPAN-SQUASH" "PEACH" "PARSLEY" "CHILI" 
              "DANDELION" "PISTACHIO" "PEAR" "LEEK" "PEA" "PEPPER" "BELL-PEPPER" "APPLE" 
              "POMELO" "PUMPKIN" "REDCURRI-SQUASH" "PLUM" "RADISH" "HORSERADISH" "GRAPE" "ROCKET" 
              "RUTABAGA" "RHUBARB" "SAMPHIRE" "SALSIFY" "SOY" "JERUSALEM-ARTICHOKE" "TOMATE" "WASABI"))

(define (is-uppercase? char)
  ; Returns true if the character is an unaccented uppercase letter.
  ; char -> boolean
  (if (not (char? char)) 
      (begin (display "Invalid symbol") #f)
      (and (char>=? char #\A) (char<=? char #\Z))))

(define (is-uppercase-list? lst)
  ; Returns true if all elements in the list are unaccented uppercase letters.
  ; char list -> boolean
  (cond
    ((null? lst) #t) 
    ((is-uppercase? (car lst)) (is-uppercase-list? (cdr lst)))
    (else #f)))

(define (is-member? char char-list)
  ; Returns true if the character is an element of the list.
  ; char, char list -> boolean
  (cond 
    ((null? char-list) #f)
    ((char=? char (car char-list)) #t)
    (else (is-member? char (cdr char-list)))))

(define (insert char char-list)
  ; Returns char-list sorted with the new character included.
  ; char, sorted char list -> char list
  (cond
    ((null? char-list) (list char))
    ((char=? char (car char-list)) char-list) 
    ((char<? char (car char-list)) (cons char char-list)) 
    (else (cons (car char-list) (insert char (cdr char-list))))))

(define (display-elements char-list)
  ; Displays elements of char-list on screen separated by spaces.
  ; char list -> Display
  (if (null? char-list) 
      (display "")
      (begin
        (display (car char-list))
        (display " ")
        (display-elements (cdr char-list)))))

(define (input-letter char-list)
  ; Prompts user for a letter and validates if it is uppercase and unique.
  ; char list -> char
  (begin
    (display "Propose a letter, letters already proposed: ")
    (display char-list)
    (display " > ")
    (let* ((input (read)) 
           (char (string-ref (symbol->string input) 0))) 
      (if (or (not (is-uppercase? char)) (is-member? char char-list))
          (begin
            (display "Invalid input. Please type an uppercase letter not yet proposed.")
            (newline)
            (input-letter char-list))
          char))))


;;--------------- 2 String Manipulation ---------------


(define (replace-char char str index)
  ; Returns string where the character at the specific index is replaced.
  ; char, string, integer -> string
  (if (string=? str "") 
      (string char)
      (string-append (substring str 0 index) 
                     (string char) 
                     (substring str (+ index 1) (string-length str)))))

(define (replace-chars char str index-list)
  ; Replaces character in string at all provided indices.
  ; char, string, integer list -> string
  (if (null? index-list) 
      str
      (replace-chars char (replace-char char str (car index-list)) (cdr index-list))))

(define (mask-string str)
  ; Returns a string of hyphens with the same length as the input.
  ; string -> string
  (if (= (string-length str) 0) 
      ""
      (string-append "-" (mask-string (substring str 1 (string-length str))))))

(define (find-indices char str)
  ; Returns a list of indices where the character appears in the string.
  ; char, string -> integer list
  (find-indices-helper char str 0))

(define (find-indices-helper char str index)
  ; Helper function to traverse the string with an index accumulator.
  ; char, string, integer -> integer list
  (if (= index (string-length str)) 
      '()
      (if (char=? char (string-ref str index))
          (cons index (find-indices-helper char str (+ index 1)))
          (find-indices-helper char str (+ index 1)))))


;;------------------------------ 3 Game Logic ------------------------------


(define (display-win-message errors word)
  ; Displays victory message with the total error count.
  ; integer, string -> Display
  (begin 
    (display "Congratulations! You found ") (display word) 
    (display " with only ") (display errors)
    (if (> errors 1) (display " errors.") (display " error."))
    (newline)))

(define (display-loss-message word)
  ; Displays defeat message and reveals the secret word.
  ; string -> Display
  (begin
    (display "Max errors reached. Game Over. The word was: ")
    (display word)
    (display ".")
    (newline)))

(define (display-status errors current-word)
  ; Displays the masked word and the current error count.
  ; integer, string -> Display
  (begin
    (display "Word to guess: ")
    (display current-word)
    (newline)
    (display "Errors committed: ")
    (display errors)
    (newline)))

(define (hangman errors proposed-list current-state target-word max-errors)
  ; Core recursive game loop.
  ; int, char list, string, string, int -> Display
  (begin
    (display-status errors current-state)
    (let* ((letter (input-letter proposed-list))
           (updated-list (insert letter proposed-list))
           (indices (find-indices letter target-word)))
      (if (null? indices)
          ; Case: Wrong guess
          (begin
            (display "There is no ") (display letter) (display " in the word.")
            (newline)
            (if (< (+ errors 1) max-errors)
                (hangman (+ errors 1) updated-list current-state target-word max-errors)
                (display-loss-message target-word)))
          ; Case: Correct guess
          (let ((new-state (replace-chars letter current-state indices)))
            (if (string=? new-state target-word)
                (display-win-message errors target-word)
                (hangman errors updated-list new-state target-word max-errors)))))))


;;------------------------------ 4 Execution ------------------------------

(define (get-random-word word-list)
  (let ((index (random (length word-list))))
    (list-ref word-list index)))

(define (count-unique-chars word)
  ; Returns the number of unique characters in a string
  (let ((char-list (string->list word)))
    (letrec ((unique-helper (lambda (lst seen)
                              (cond ((null? lst) 0)
                                    ((is-member? (car lst) seen) (unique-helper (cdr lst) seen))
                                    (else (+ 1 (unique-helper (cdr lst) (cons (car lst) seen))))))))
      (unique-helper char-list '()))))

(define (start-game)
  (begin
    (let* ((word (get-random-word words))
           (unique-count (count-unique-chars word))
           ;; Dynamic Limit: 1.5 times the unique letters, rounded down
           (calculated-limit (inexact->exact (floor (* unique-count 1.5)))))
      
      ;; Ensure the limit is within a playable range [5 - 12]
      (let ((final-limit (cond ((< calculated-limit 5) 5)
                               ((> calculated-limit 12) 12)
                               (else calculated-limit))))
        (begin
          (newline)
          (display "--- NEW GAME ---") (newline)
          (display "A secret word has been chosen.") (newline)
          (display "Based on word complexity, you have ") 
          (display final-limit) (display " allowed errors.") (newline)
          (newline)
          (hangman 0 '() (mask-string word) word final-limit)
          ;; 2. Prompt for restart
           (display "Do you want to play again? (Y/N): ")
           (let* ((choice-symbol (read))
                  (choice-char (string-ref (symbol->string choice-symbol) 0)))
             (if (or (char=? choice-char #\Y) (char=? choice-char #\y))
                 (begin
                   (newline)
                   (start-game)) ;; Restart
                 (begin
                   (display "Thanks for playing! Goodbye.")
                   (newline))))))))) ;; Stop 