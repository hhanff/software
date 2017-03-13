
(quote (+ 3 5)) ; quote wntspricht puts
'Artichoke  ; ' ist ein Synonym für quote
(/ (- 7 1) ( - 4 2)) ; erst der Funktionsaufruf (Operator), dann die Argumente
(+ 2 3 4 5)
'(my 3 "Sons")
'(the list (a b c) has 3 elements) ; Die erste Liste
( list 'my (+ 2 1) "Sons") ; Listen
(listp ( a b c)) ; Überprüfe, ob das Argument eine Liste ist. In diesem Fall T
(listp 27); Überprüfe, ob das Argument eine Liste ist. In diesem Fall NIL
; Eine if/else Bedingung
(if ( listp ' ( a b c))
    (+ 1 2)    ; if
    (+ 5 6))   ; else
(if 27 1 2) ; Wenn 27, dann 1. Sonst 2. Alles außer NIL gilt als Wahr. Damit liefert die Abfrage 1.
(defun our-third (x); Definition einer neuen Funktion mit x als Parameter
  (car (cdr (cdr x ) ) ) ); Body der Funktion
