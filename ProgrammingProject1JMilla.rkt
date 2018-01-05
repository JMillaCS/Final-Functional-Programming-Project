;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ProgrammingProject1JMilla) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
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

;;DATA DEFINITION
;;A LoV(list-of-votes) is one of:
;;-empty
;;-(cons vote LoV)
(define voteList (list vote0 vote1 vote2 vote3 vote4 vote5 vote6 vote7 vote8 vote9))

;;signature:top-votes-for: String LoV->Number
;;purpose: Consumes a string and a list-of-votes and produces the number of times
;;that the given name was the first pick in the votes list. This is the WINNER TAKES ALL
;;strategy and USES top-points-for AS A HELPER FUNCTION.
;;test:
(check-expect (top-votes-for "Bernie Sanders" voteList) 2)
(check-expect (top-votes-for "Hillary Clinton" voteList) 3)
(check-expect (top-votes-for "Hillary Clinton" (list )) 0)
;;function definition:
(define (top-votes-for name aLoV)
  (cond
    [(empty? aLoV) 0]
    [else (+ (top-points-for name (first aLoV)) (top-votes-for name (rest aLoV)))]))

;;signature:top-two-votes-for: String LoV->Number
;;purpose: Consumes a string and a list-of-votes and produces the number of times
;;that the given name was the first or second pick in the votes list. This
;;is the APPROVAL-RATING strategy and USES top-two-points-for AS A HELPER FUNCTION.
;;test:
(check-expect (top-two-votes-for "Donald Trump" voteList) 4)
(check-expect (top-two-votes-for "Harambe" voteList) 4)
(check-expect (top-two-votes-for "Harambe" (list )) 0)
;;function definition:
(define (top-two-votes-for name aLoV)
  (cond
    [(empty? aLoV) 0]
    [else (+ (top-two-points-for name (first aLoV)) (top-two-votes-for name (rest aLoV)))]))

;;signature:total-points-for: String Lov->Number
;;purpose: Consumes a string and a list-of-votes and produces the total amount of
;;points for the given candidate based off a points per place system. This is the
;;POINTS-PER-PLACE strategy and USES points-per-place-for AS A HELPER FUNCTION.
;;test:
(check-expect (total-points-for "Hillary Clinton" voteList) 16)
(check-expect (total-points-for "Donald Trump" voteList) 10)
(check-expect (total-points-for "Hillary Clinton" (list )) 0)
;;function definition:
(define (total-points-for name aLoV)
  (cond
    [(empty? aLoV) 0]
    [else (+ (points-per-place-for name (first aLoV)) (total-points-for name (rest aLoV)))]))

;;DATA DEFINITIONS
(define-struct voting-tally (name numofvotes))
;;A voting-tally is a structure.(make-voting-tally String Number)
;;Interp.:Takes the name of a candidate(String) and the number of votes
;;the candidate has recieved(Number)

;;A LoVT(list-of-voting-tally) is one of:
;;-empty
;;(cons voting-tally LoVT)
(define firstLoVT (list (make-voting-tally "Donald Trump" 0) (make-voting-tally "Hillary Clinton" 1)))
;;signature:tally-by-all:list-of-names LoV->LoVT
;;purpose:consumes a list of candidates names and a LoV and produces a list of voting-tallies.
;;The produced list should have one tally for each candidate. The number of votes in the tally for a
;;candidate should be the number of votes that candidate recieve under the  WINNER
;;TAKES ALL strategy. USES top-votes-for AS A HELPER FUNCTION.
;;test:
(check-expect (tally-by-all (list "Donald Trump" "Hillary Clinton" "Bernie Sanders" "Harambe" "Gary Johnson") voteList)
              (list (make-voting-tally "Donald Trump" 1) (make-voting-tally "Hillary Clinton" 3) (make-voting-tally "Bernie Sanders" 2)
                    (make-voting-tally "Harambe" 2) (make-voting-tally "Gary Johnson" 2)))
(check-expect (tally-by-all (list )  (list (make-voting-tally "Donald Trump" 1) (make-voting-tally "Hillary Clinton" 3) (make-voting-tally "Bernie Sanders" 2)
                    (make-voting-tally "Harambe" 2) (make-voting-tally "Gary Johnson" 2))) empty)
;;function definition:
(define (tally-by-all alon aLoV)
 (tally-by top-votes-for alon aLoV))

;;signature:tally-by-approval: list-of-name(list of strings) LoV->LoVT
;;purpose: Consumes a list-of-candidates names which is a list of strings and
;; a list of votes and returns a list of voting-tallies. The produced list should
;;have one tally for each candidate. The number of votes in the tally for a candidate
;;should be the number of votes that candidate received under the APPROVAL-RATING strategy.
;;USES top-two-votes-for AS A HELPER FUNCTION.
;;test:
(check-expect (tally-by-approval (list "Donald Trump" "Hillary Clinton" "Bernie Sanders" "Harambe" "Gary Johnson") voteList)
              (list (make-voting-tally "Donald Trump" 4) (make-voting-tally "Hillary Clinton" 4) (make-voting-tally "Bernie Sanders" 4)
                    (make-voting-tally "Harambe" 4) (make-voting-tally "Gary Johnson" 4)))
(check-expect (tally-by-approval (list )  (list (make-voting-tally "Donald Trump" 4) (make-voting-tally "Hillary Clinton" 4) (make-voting-tally "Bernie Sanders" 4)
                    (make-voting-tally "Harambe" 4) (make-voting-tally "Gary Johnson" 4))) empty) 
;;function definition:
(define (tally-by-approval alos aLoV)
    (tally-by top-two-votes-for alos aLoV))

;;signature:tally-by-place: list-of-names(list of strings) LoV->LoVT
;;purpose:consumes a list of candidate names (list of strings) and a list of votes.
;;It produces a list of voting tallies according to the POINTS-PER-PLACE strategy.
;;USES total-points-for AS A HELPER FUNCTION.
;;test:
(check-expect (tally-by-place (list "Donald Trump" "Hillary Clinton" "Bernie Sanders" "Harambe" "Gary Johnson") voteList)
                              (list (make-voting-tally "Donald Trump" 10) (make-voting-tally "Hillary Clinton" 16) (make-voting-tally "Bernie Sanders" 10)
                    (make-voting-tally "Harambe" 12) (make-voting-tally "Gary Johnson" 12)))
(check-expect (tally-by-place (list ) (list (make-voting-tally "Donald Trump" 10) (make-voting-tally "Hillary Clinton" 16) (make-voting-tally "Bernie Sanders" 10)
                    (make-voting-tally "Harambe" 12) (make-voting-tally "Gary Johnson" 12))) empty)
;;function definition:
(define (tally-by-place alos aLoV)
  (tally-by total-points-for alos aLoV))

;;signature:eliminate-no-votes: LoVT->LoVT
;;purpose:consumes a list of voting-tally and produces alist of those tallies
;;in which the candidate received at least one vote.
;;test:
(check-expect (eliminate-no-votes (list (make-voting-tally "Donald Trump" 10) (make-voting-tally "Hillary Clinton" 16) (make-voting-tally "Bernie Sanders" 10)
                    (make-voting-tally "Harambe" 12) (make-voting-tally "Gary Johnson" 12)))
                    (list (make-voting-tally "Donald Trump" 10) (make-voting-tally "Hillary Clinton" 16) (make-voting-tally "Bernie Sanders" 10)
                    (make-voting-tally "Harambe" 12) (make-voting-tally "Gary Johnson" 12)))
(check-expect (eliminate-no-votes (list )) empty)
(check-expect (eliminate-no-votes firstLoVT) (list (make-voting-tally "Hillary Clinton" 1)))
;;function definition:
(define (eliminate-no-votes aLoVT)
  (cond
    [(empty? aLoVT) empty]
    [(> (voting-tally-numofvotes (first aLoVT)) 0)(cons (first aLoVT) (eliminate-no-votes (rest aLoVT)))]
    [else (eliminate-no-votes (rest aLoVT))]))

;;signature:top-three:some-function(list-of-string LoV-> LoVT) list-of-names LoV->LoVT
;;purpose:Consumes some-function (tally-by-all, tally-by-approval, OR tally-by-place)
;;a list of the names of the candidates (lsit of strings) and a list of votes.
;;This ABSTRACTED function returns a List-of-Voting-Tally that has the candidates in
;;order from most to least votes, that way you can see which candidate places where
;;when different voting strategies are used.

;;signature:tie-breaker:some-function(list-of-string LoV-> LoVT) list-of-names LoV->LoVT
;;purpose:Consumes some-function (tally-by-all, tally-by-approval, OR tally-by-place),
;;a list of the names of the candidates (list of strings), and a list of votes.
;;This ABSTRACTED function returns a List-of-Voting-Tally that has the candidates in
;;order from most to least votes, that way you can see which candidate places where
;;when different voting strategies are used.THIS DEALS WITH THE ANY TIES.

;;signature:running?:String Lov->Boolean
;;purpose:consumes a name of a possible candidate and a list of votes.
;;Returns true if the candidate is in the list or false otherwise.


;;BEGINNING OF PROJECT 2
;;signature:tally-by:function Lon LoV->LoVT
(define (tally-by function aLon aLoV)
 (cond
    [(empty? aLon) empty]
    [else (cons (make-voting-tally (first aLon) (function (first aLon) aLoV)) (tally-by function (rest aLon) aLoV))]))
    

;;EXTEND YOUR PROGRAM
;;DATA DEFINITION:
;;A Lon (list-of-numbers) is one of:
;;-empty
;;-cons Number Lon

;;signature:largest-num:Lon->Number
;;purpose:consumes a list-of-numbers and returns the largest number in the list
;;test:
(check-expect (largest-num (list 1 3 7 5)) 7)
(check-expect (largest-num (list 1 7 3 4 2)) 7)
(check-expect (largest-num (list 1 2 3 4 6 8)) 8)
(check-expect (largest-num (list )) 0)
;;fucntion definition:
(define (largest-num aLon)
  (cond
    [(empty? aLon) 0]
    ;;[(empty? (rest aLon)) (first aLon)]
    ;;[(< (first aLon) (first (rest aLon))) (largest-num (rest aLon))]
    [(> (first aLon) (largest-num (rest aLon))) (first aLon)]
    [else (largest-num (rest aLon))]))
 ;;original: [(largest-num (cons (first aLon) (cons (first(rest aLon)))))]


;;signature:largest-tally: LoVT->voting-tally
;;purpose:consumes a lost of voting-tallies and returns the votin-tally with the
;;largest amount of points. MUST BE CALLED WITH AN NON-EMPTY LIST.
;;test:
(check-expect (largest-tally (list (make-voting-tally "Bernie Sanders" 3)
                                   (make-voting-tally "Hillary Clinton" 4))) (make-voting-tally "Hillary Clinton" 4))
(check-expect (largest-tally (list  )) (make-voting-tally "Dummy VoteTally" 0))
(check-expect (largest-tally (list (make-voting-tally "Bernie Sanders" 4)
                                   (make-voting-tally "Hillary Clinton" 3)
                                   (make-voting-tally "Harambe" 6))) (make-voting-tally "Harambe" 6))
;;fucntion definition: 
(define (largest-tally aLoVT)
  (cond
    [(empty? aLoVT) (make-voting-tally "Dummy VoteTally" 0)]
    [(> (voting-tally-numofvotes (first aLoVT)) (voting-tally-numofvotes (largest-tally (rest aLoVT)))) (first aLoVT)]
    [else (largest-tally (rest aLoVT))]))

 (define listofcans
   (list "Donald Trump" "Hillary Clinton" "Bernie Sanders" "Harambe" "Gary Johnson"))
;;signature:winner-by-all:Los(list-of-strings) LoV(list-of-votes)->String
;;purpose:consumes a list of the names of the candidates and a list of votes, and
;;returns the name of the candidate that wins by the WINNER-TAKES-ALL strategy.
;;test:
(check-expect (winner-by-all listofcans voteList) "Hillary Clinton")
;;function definition:
(define (winner-by-all aLos aLoV)
  (voting-tally-name (largest-tally (tally-by top-votes-for aLos aLoV))))

(define voteList2 (list (make-vote "Bernie Sanders" "Hillary Clinton" "Harambe")
                  (make-vote "Bernie Sanders" "Gary Johnson" "Donald Trump")))
;;signature:winner-by-approval:Los(list-of-strings) LoV(list-of-votes)->String
;;purpose:consumes a list of names of the candidates and a list of votes, and
;;returns the name of the name of the candidate that wins by the APPROVAL RATING strategy.
;;test:
(check-expect (winner-by-approval listofcans voteList2) "Bernie Sanders")
;;function definition:
(define (winner-by-approval aLos aLoV)
  (voting-tally-name (largest-tally (tally-by top-two-votes-for aLos aLoV))))

;;signature:winner-by-points-per-place:Los(list-of-strings) LoV(list-of-votes)->String
;;purpose:consumes a list of names of the candidates and a list of votes, and
;;returns the name of the name of the candidate that wins by the POINTS-PER-PLACE strategy.
;;test:
(check-expect (winner-by-points-per-place listofcans voteList) "Hillary Clinton")
;;function definition:
(define (winner-by-points-per-place aLos aLoV)
 (voting-tally-name (largest-tally (tally-by total-points-for aLos aLoV))))

;;ABSTRACTED FUNCTION: winner-by
;;signature:winner-by:forfunction(String LoV-> Number) Los(list-of-strings) LoV(list-of-votes)->String
;;consumes a function (one of the helper functions used in the tally-by functions;
;; top-votes-for, top-two-votes-for, or total-points-for); a list of the names of
;;the candidates, and a LoV(list-of-votes). It will apply the given forfunction to
;;figure out who is the winner given one of the three helper functions, who correlate
;;respectively to either winner-takes-all, approval rating, points-per-place strategy.
;;test:
(check-expect (winner-by total-points-for listofcans voteList) "Hillary Clinton")
(check-expect (winner-by top-two-votes-for listofcans voteList2) "Bernie Sanders")
;;function definition:
(define (winner-by forfunc aLos aLoV)
  (voting-tally-name (largest-tally (tally-by forfunc aLos aLoV))))







