;;; Hash functions

(defun table-pop (key table)
  (pop (gethash key table)))

(defun table-push (key table)
  (when (push
         '(1)
         (gethash key table))
    table))

;;; String-to-list compatibility functions

(defun str-rest (string)
  (unless (equal string "")
    (subseq string 1)))

(defun str-second (string)
  (subseq string 1 2))

(defun str-first (string)
  (unless (equal string "")
    (subseq string 0 1)))


;;; Look for word letters in the hash (in order)

(defun loop-word-in-hash-comp (word hash
                               &optional
                                 (f-first #'first)
                                 (f-rest #'rest))
  (when (funcall f-first word) ; nil if the word is empty
    (do ((aux-word word (funcall f-rest aux-word))) ; Try to hash the current letter
        ((or (not word)                             ; until you find one that isn't
             (not (table-pop (funcall f-first aux-word) hash)))
         aux-word)))) ; return the word starting with the first letter not in the hash

(defun rec-word-in-hash-comp (word hash
                              &optional
                                (f-first #'first)
                                (f-rest #'rest))
  (when word ; nil if the word is empty
    (if (table-pop (funcall f-first word) hash) ; if can hash the current letter
                                        ; call yourself
        (rec-word-in-hash-comp (funcall f-rest word) hash f-first f-rest)
        word))) ; return the word starting with the first letter not in the hash


;;; Main function (handler and auxiliary)

(defun can-i-write-aux-comp (word bag-of-letters hash func-word-in-hash
                             &optional
                               (f-first #'first)
                               (f-rest #'rest))
  (if (and word bag-of-letters) ; If there are still letters in both cases
      (can-i-write-aux-comp     ; recursion over the..
       (funcall func-word-in-hash word  ; letters not in the..
                (table-push             ; hash once the first letter is introduced
                 (funcall f-first bag-of-letters) 
                 hash)
                f-first f-rest)
       (funcall f-rest bag-of-letters) ; the rest of the bag is iterated due to the
       hash                            ; first element already in the hash
       func-word-in-hash f-first f-rest)
      (not word))) ; if one arg is empty, T is returned if all the elements have been found
                                        ; NIL otherwise

  (defun can-i-write-comp (word bag-of-letters func-word-in-hash
                           &optional
                             (f-first #'first)
                             (f-rest #'rest)
                             (size '300))
    (can-i-write-aux-comp ; call the auxiliary with a hash
     word bag-of-letters
     (make-hash-table :size size :test #'equal) ; the test is specified for the String case
     func-word-in-hash
     f-first
     f-rest))


(defun can-i-write-loop-str (word bag-of-letters)
  (can-i-write-comp word bag-of-letters #'loop-word-in-hash-comp #'str-first #'str-rest))

(defun can-i-write-rec-str (word bag-of-letters)
  (can-i-write-comp word bag-of-letters #'rec-word-in-hash-comp #'str-first #'str-rest))

(defun can-i-write-loop-list (word bag-of-letters)
  (can-i-write-comp word bag-of-letters #'loop-word-in-hash-comp))

(defun can-i-write-rec-list (word bag-of-letters)
  (can-i-write-comp word bag-of-letters #'rec-word-in-hash-comp))

