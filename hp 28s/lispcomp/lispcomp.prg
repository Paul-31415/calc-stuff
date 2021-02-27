-----
Well, here it is: Crwth-Lisp 3.2!

The impact Crwth-Lisp 3.1 made on the net was beyond my wildest dreams.

Suggestions, hints, bug-reports, flames and loveletters are welcome (though
I hope I will receive no bug-reports!).

Changes since Crwth-Lisp 3.1 are listed in the preface of the manual.

                                /Crwth

                                    ; Crwth-Lisp 3.2
                                    ; A Lisp Compiler for the HP28S
                                    ; by Olle Gallmo (Crwth) 1988
                                    ; -----
LISP ( L-expr --- Value )           ; Compile an L-expr to a program block
<< COMP ->PROG STR-> EVAL           ; and evaluate it
>>                                  ; 
                                    ; -----
COMP ( L-expr --- String )          ; Compile an L-expr to a string of
<< IF DUP TYPE 5 SAME THEN          ; HP28-instructions
     CLIST                          ; Lists
   ELSE                             ;
     IF DUP TYPE 6 SAME THEN        ; Atoms
       CATOM                        ;
     ELSE                           ;
       IF DUP TYPE 2 SAME THEN      ; Strings
         34 CHR SWAP OVER + +       ;   A string in a string!
       ELSE                         ;
         ->STR                      ; Others
       END                          ;
     END                            ;
   END                              ;
   " " +                            ;
>>                                  ; 
                                    ; -----
CLIST ( List --- String )           ; Compile a list
<< IF DUP {} SAME THEN              ; An empty list compiles to itself
     DROP "{}"                      ;
   ELSE                             ;
     DUP REST SWAP 1 GET            ; Get tail and head
     IF SPA OVER POS THEN           ; If Functor is a special form
       SPB SPA ROT POS GET EVAL     ;   compile special form
     ELSE                           ;
       CFUN                         ; Else compile a normal funcall
     END                            ;
   END                              ;
>>                                  ; 
                                    ; -----
CATOM ( Atom --- String )           ; Compile an atom
<< IF MACA OVER POS DUP THEN        ; If the atom is defined as a macro
     SWAP DROP MACB SWAP GET        ;   get the corresponding string
   ELSE                             ;
     DROP ->STR 2 OVER SIZE 1 - SUB ; Else Convert to string and delete the 's
   END                              ;
>>                                  ; 
                                    ; -----
CFUN ( Arglist Functor --- String ) ; Compile a funcall
<< COMP SWAP                        ; Compile the functor
   IF DUP SIZE THEN                 ; If funcall has arguments
     CSEQ SWAP +                    ;   compile them first and add the functor
   ELSE                             ;
     DROP                           ; Else just return the functor
   END                              ;
>>                                  ; 
                                    ; -----
CSEQ ( Arglist --- String )         ; Compile a sequence of funcalls
<< "" 1 3 PICK SIZE FOR i           ; (for instance the body of a DEFUN,
     OVER i GET COMP +              ; LET or COND)
   NEXT                             ;
   SWAP DROP                        ;
>>                                  ;
                                    ; -----
SPQ ( Arglist --- String )          ; Compile special form QUOTE
<< 1 GET ->STR                      ;
>>                                  ; 
                                    ; -----
SPDEF ( Arglist --- String )        ; Compile special form DEFUN
<< DUP CDEF ->PROG STR->            ; Compile the definition
   SWAP 1 GET STO "1"               ; Store in a variable
>>                                  ; 
                                    ; -----
SPMAC ( Arglist --- String )        ; Compile special form DEFMAC
<< DUP CDEF MACB + 'MACB' STO       ; Compile the definition into MACB
   1 GET MACA + 'MACA' STO "1"      ; and store the macro-name in MACA
>>                                  ;
                                    ;
CDEF (Arglist --- String )          ; Compile a definition (DEFUN or DEFMAC)
<< DUP 3 OVER SIZE SUB CSEQ         ; Compile the body
   SWAP 2 GET                       ; Get the parameter-list
   IF DUP SIZE THEN                 ; If function takes arguments
     CSEQ "-> " SWAP +              ;   create local variables for them
     SWAP ->PROG +                  ;   and add the compiled body
   ELSE                             ; Else
     DROP                           ;   just leave the compiled body
   END                              ;
>>                                  ;
                                    ; -----
SPLET ( Arglist --- String )        ; Compile special form LET
<< DUP REST CSEQ ->PROG             ; Compile the body
   SWAP 1 GET                       ; Get declarations
   "" 1 3 PICK SIZE FOR i           ; Compile values of the local variables
     OVER i GET 2 GET COMP +        ;
   NEXT                             ;
   "-> " +                          ;
   1 3 PICK SIZE FOR i              ; Create corresponding HP28-code
     OVER i GET 1 GET COMP +        ; local variables
   NEXT                             ;
   SWAP DROP SWAP +                 ; and add the compiled body
>>                                  ; 
                                    ; -----
SPCOND ( Arglist --- String )       ; Compile special form COND
<< IF DUP SIZE 1 SAME THEN          ; If only one test left
     1 GET DUP 1 GET COMP           ;
     IF DUP "1 " SAME THEN          ;   If it is an 'else'
       DROP REST CSEQ               ;     just compile
     ELSE                           ;   Else
       "IF " SWAP + "THEN " +       ;     Create an IF-THEN-END
       SWAP REST CSEQ + "END " +    ;
     END                            ;
   ELSE                             ; Else
     "IF " OVER 1 GET 1 GET COMP +  ;   Create an IF-THEN-ELSE-SPCOND-END
     "THEN " +                      ;
     OVER 1 GET REST CSEQ +         ;
     "ELSE " +                      ;
     SWAP REST SPCOND +             ;
     "END " +                       ;
   END                              ;
>>                                  ; 
                                    ; -----
SPA                                 ; List of special forms
{ QUOTE DEFUN DEFMAC LET COND }     ;
                                    ; -----
SPB                                 ; List of corresponding compiling words
{ SPQ SPDEF SPMAC SPLET SPCOND }    ;
                                    ; -----
MACA                                ; List of macros
{ T NIL }                           ;
                                    ; -----
MACB                                ; List of corresponding strings
{ "1" "0"}                          ;
                                    ; -----
->PROG ( String --- String )        ; Put program delimiters on both sides
<< "<< " SWAP + ">> " +             ; of a HP28-code string
>>                                  ; 
                                    ; -----
REST                                ; Get the tail of a list
<< 2 OVER SIZE SUB                  ;
>>                                  ;
                                    ; -----
-- 
Olle Gallmo (Crwth)
Email: crwth@kuling.UU.SE
Real: Skyttevagen 68, 181 46  Lidingo, Sweden


