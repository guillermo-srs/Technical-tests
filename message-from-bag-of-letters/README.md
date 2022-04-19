# Message from bag of letters

## Problem description

Imagine we have a bag with letters. We want to know if we can create a message with those letters. Your mission is to write a function that takes two inputs:

-   The message you want to write: It will be a message with letters and spaces, nothing else.
-   All available letters in the bag: Also, you will find just letters and spaces

**Be aware of:**

-   We can have many letters (lowercase) in the bag, and we could want to write messages of any length with those letters.
-   Each letter can be repeated many times and it doesn't have to be repeated a similar number of times. Some of the letters can be missing. Also, the letters will be ordered randomly.

The function you have to write has to determine if you can write the message with the letters in the bag. The function will return True if you can, False otherwise. Implement the most efficient option for your function. Assume the message and the bag of letters are well-formatted, you don't have to clean the strings or do any changes to them. Here you have an input example:

-   message `= "hello world"`

-   bag `= "oll hw or aidsj iejsjhllalelilolu r"`

After writing the function, please provide the efficiency in Big-O notation considering the length of your message as "m" and the number of the letters in your bag as "b". Explain the efficiency calculation.

## Problem analysis

In order to analyze the problem, we can start by reducing it to its main issues. These can be summarized as: i) finding elements from one of the strings and ii) comparing elements between them. Hence, the main factors that will affect performance (and can be addressed) are:

-   **Times an element is required** (number of comparisons required to perform the algorithm): For every key operation applied to an element, a number of comparisons will be carried out in order to determine a certain meaning to the element (position, number of appearances, existence, etc.). Thereby, the bigger this number of comparison the higher the complexity will be.
-   **Data access costs** (number of comparisons to find an element): Every time a pair of values are to be compared, the program needs access to at least one of them -the other can be a pivot in the algorithm-, and for every comparison performed the complexity will be multiplied by this factor.

And of course, in terms of space complexity we will have to pay attention to the allocation of data required by the selected structure(s). However, given that the objective of this test is to focus on performance, this issue will not be prioritized over the main one.

Thus, the algorithmic design should be focused in reducing the total number of element comparisons through less functional operations (understanding this as iterations required by the main flow of the algorithm) and less data accesses.

## Theoretical approach

To solve the first problem, this work suggests to take advantage of each comparison performed to improve future costs, and thereby, reduce the number of searches required by the main algorithm. For example, performing a Quicksort over the `bag` string with two pivots. One from the `bag` itself, and one from the `word`.

On the other hand, the approach presented by this work to the second problem is to use a hash table. The reason behind it is that, on an ideal case, a hash table will have a $\mathcal{O}(1)$ access cost. However, the introduction of an additional structure implies that the former must be assembled from the data. Following the idea of the first paragraph, the structure will be assembled as a result of failed comparisons instead of being a process on its own.

Hence, the solution to the problem will be something similar to the following:

```pseudocode
def can_i_write_it(word bag):
  create hash
  foreach candidate in word:
    foreach element in bag:
      add element to hash
      remove element from bag
      if candidate in hash:
        remove element from word and hash
        break
      else if bag is empty:
        return False
  return True
```

**Please notice that this is a pseudocode example and it does not represent the final solution**. It is just a simple description of the algorithm to analyze its costs.

## Theoretical cost

The cost of the previous pseudocode can be summarized as the combination of the number of iterations of both loops. The basic operation is the first `if` (line 7) and it only depends on the previous mentioned loops.

The second loop (line 4) iterates over each element of the bag until the end, except when every element of the word is located. However, this cost is not multiplied by the first loop because once an element is iterated from the bag, it is removed from it. Hence the average cost of this loop is $b/2 \sim \mathcal{O}(b)$

For the second loop (line 3) the average cost will be $w$ always, except for those cases when the bag runs out before the whole word is analyzed. Then, the average cost will be


$$
w/2 * P(W= \text{bag shorter than word} ) + w * (1 - P(W)).
$$
Finally, we can combine these estimations with a sum, because every time an element from the
`bag` is extracted, it is also removed from it (as we defined before).


$$
b + w/2 * P(W) + w * (1 - P(W)).
$$

Which can be reduced as,

$$
b + w * [1 - P(W)/2].
$$
And this, in the average case scenario, is:
$$
\mathcal{O}(\max\{w,b\}).
$$

## Solution

The language chosen to solve this problem is Common Lisp. The algorithm described in the previous section is implemented in 3 parts:

-   Hash structure
-   Iterative search of word elements' in the Hash
-   Main algorithm

It is important to take into account that this algorithm was designed for both arguments -`word` and `bag`- to be lists. However, it has been adapted for the case of `Strings`, and with minor adjustments can be used for both cases.

### Hash

Even though the structure is already defined in Common Lisp, we define two functions (push and pop) to add access transparencies to this implementation.

- table-push: This function pushes an element into the hash, increasing its value, if it exists, or assigning it to one. Finally it returns the hash. Even though this is not necessary since the hash is modified in the push, it simplifies the use of the function in the future.

  ```lisp
  (defun table-push (key table)
  	(when (push
  		'(1)
  		(gethash key table))
  		table)) 
  ```

  table-pop: This function takes and element and a hash and decreases the value of the element if it exists. In any other case the function removes it. Finally, it returns the value of the element or null if it does not exist.

  ```lisp
  (defun table-pop (key table)
    (pop (gethash key table)))
  ```

  

### Iterative search of word elements' in the Hash

For this part of the implementation, two different functions are provided. The only difference is that one uses a recursion (`rec-word-in-hash-comp`) and the other one uses a loop (`loop-word-in-hash-comp`). The need for the alternate implementation was motivated for the lack of (as far as I know) queue recursion control in Common Lisp.

```lisp
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
      (if (table-pop (funcall f-first word) hash) ; if current letter can be hashed
                                        ; call yourself
          (rec-word-in-hash-comp (funcall f-rest word) hash f-first f-rest)
          word))) ; return the word starting with the first letter not in the hash
```

One can notice that both functions receive an optional method for the MACROS `first` and `rest`. This was implemented this way to allow the use of `Strings` and `Lists` indifferently.

```lisp
(defun str-rest (string)
  (unless (equal string "")
    (subseq string 1)))

(defun str-first (string)
  (unless (equal string "")
    (subseq string 0 1)))
```

### Main algorithm

The main algorithm is implemented as a two function recursion (a handler and an auxiliary) so the hash is transparent to the user. The user can specify the `first` and `rest` functions (to the `String` case, otherwise they use the standards) and the initial size of the hash. However, the user must specify the strategy to use, for the reasons described in the previous section.

```lisp
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
```

## Tests

In order to fit the problems specifications we define four functions with two arguments each. One function for every configuration according to the code included in the section [1.5](#orgc2eddcf). 

```lisp
(defun can-i-write-loop-str (word bag-of-letters)
  (can-i-write-comp word bag-of-letters #'loop-word-in-hash-comp #'str-first #'str-rest))

(defun can-i-write-rec-str (word bag-of-letters)
  (can-i-write-comp word bag-of-letters #'rec-word-in-hash-comp #'str-first #'str-rest))

(defun can-i-write-loop-list (word bag-of-letters)
  (can-i-write-comp word bag-of-letters #'loop-word-in-hash-comp))

(defun can-i-write-rec-list (word bag-of-letters)
  (can-i-write-comp word bag-of-letters #'rec-word-in-hash-comp))
```

Finally we perform some tests for different scenarios.

```lisp
> (can-i-write-loop-str "" "") 
>> T
> (can-i-write-loop-str "" nil) ; base case
>> NIL
> (can-i-write-loop-str nil nil)
>> T
> (can-i-write-loop-str "abbaaab" "bbbaaaa")
>> T
> (can-i-write-loop-str "abbaaabb" "bbbaaaa")
>> NIL
> (can-i-write-loop-str "abbaaab" "bbbaaaab")
>> T
> (can-i-write-loop-str "abbaaab" "")
>> NIL
> (can-i-write-loop-str "" "bbbaaaab")
>> T
> (can-i-write-loop-str "hola amigos!" "tusjqorholsmahirgos")
>> NIL
> (can-i-write-loop-str "hola amigos!" "tusjqorholsmahirgos!")
>> NIL
> (can-i-write-loop-str "hola amigos!" "tusjqorholsmahi rgos!")
>> NIL
> (can-i-write-loop-str "hola amigos!" "tusjqorholsmahi rgos!a")
>> T
> (can-i-write-loop-str "hola amigos!" "tusjqorholsmahirgos!a")
>> NIL
> (can-i-write-loop-str "qwertyuioplkjhgfdsazxcvbnm" "mnbvcxzasdfghjklpoiuytrewq")
>> T
> (can-i-write-loop-str "!qwertyuioplkjhgfdsazxcvbnm" "mnbvcxzasdfghjklpoiuytrewq")
>> NIL
> (can-i-write-loop-str "qwertyu ioplkjhgf dsazxcvb nm" "   mnbvcxzasdfghjklpoiuytrewq")
>> T
> (can-i-write-loop-str "qwertyu ioplkjhgf dsazxcvb nm" "  mnbvcxzasdfghjklpoiuytrewq")
>> NIL
```

