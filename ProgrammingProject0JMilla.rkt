;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ProgrammingProject0JMilla) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
;;Candidates:
;;Donald Trump
;;Hillary Clinton
;;Bernie Sanders
;;Harambe
;;Gary Johnson

(define-struct vote (choice1 choice2 choice3))
;;Data Definition:
;;A Vote is a structure. (make-vote String String String)
;;Interp.: The choices of Vote are strings whoch are names of the candidate.

(define vote0 (make-vote "Bernie Sanders" "Donald Trump" "Hillary Clinton"))
(define vote1 (make-vote "Harambe" "Gary Johnson" "Hillary Clinton"))
(define vote2 (make-vote "Bernie Sanders" "Hillary Clinton" "Harambe"))
(define vote3 (make-vote "Hillary Clinton" "Bernie Sanders" "Gary Johnson"))
(define vote4 (make-vote "Donald Trump" "Harambe" "Hillary Clinton"))
(define vote5 (make-vote "Harambe" "Gary Johnson" "Donald Trump"))
(define vote6 (make-vote "Gary Johnson" "Donald Trump" "Hillary Clinton"))
(define vote7 (make-vote "Gary Johnson" "Harambe" "Hillary Clinton"))
(define vote8 (make-vote "Hillary Clinton" "Bernie Sanders" "Gary Johnson"))
(define vote9 (make-vote "Hillary Clinton" "Donald Trump" "Harambe"))

;;top-points-for:string Vote->number
;;purpose:Takes a name and a Vote and returns 1 if that name is the first choice in the vote.
;;test:
(check-expect(top-points-for "Bernie Sanders" vote0) 1)
(check-expect(top-points-for "Bernie Sanders" vote1) 0)

;;function def:
(define (top-points-for name vote)
  (if(string=? (vote-choice1 vote) name) 1 0))

;;top-two-points-for:string Vote -> number
;;purpose:Checks if the given name is in the votes top 2 choices. If so, returns 1, otherwise returns 0.
;;test:
(check-expect(top-two-points-for "Bernie Sanders" vote0) 1)
(check-expect(top-two-points-for "Donald Trump" vote0) 1)
(check-expect(top-two-points-for "Hillary Clinton" vote0) 0)
(check-expect(top-two-points-for "Hillary Clinton" vote6) 0)


;;function def:
(define (top-two-points-for name vote)
  (if (or (string=? (vote-choice1 vote) name) (string=? (vote-choice2 vote) name)) 1 0)
 )

;;points-per-place-for:name Vote->number
;;purpose:Takes a name and a vote and gives a number (3,2,1,0) respectively to the names position
;;first, second, third, or if not top 3 will return 0.
;;test:
(check-expect (points-per-place-for "Bernie Sanders" vote0) 3)
(check-expect (points-per-place-for "Donald Trump" vote0) 2)
(check-expect (points-per-place-for "Hillary Clinton" vote0) 1)
(check-expect (points-per-place-for "Gary Johnson" vote0) 0)

;;function def:
(define (points-per-place-for name vote)
  (cond
    [(string=? name (vote-choice1 vote)) 3]
    [(string=? name (vote-choice2 vote)) 2]
    [(string=? name (vote-choice3 vote)) 1]
    [else 0]))
