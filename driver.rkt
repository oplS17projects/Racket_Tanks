#lang racket
(require lang/posn)
(require 2htdp/image)
(require 2htdp/universe)
(require racket_tanks )

;enemy tank 
;find good guy()
	; if good guy is near enemy be alerted
	; head towards good guy
	;make sure enemy is not in the way 
;		get location 
	;	fire 
		
(define randomMovement( Enemies )  
	(map  
		(lamnda (bad)
			;is enemy alive?
			(if (eq? (bad 'alive?) #t) 
				;enemy is alive true:  wait until time frame is finished
				(if (eq? (bad 'clockRunning?) #t) 
					(cond (< (bad 'time?) 0) (bad 'stop) ) 
					 ;if not choose a random acceptable time & speed .  
					(setTime_speed)
				)
				; enemy is dead
				()'
			) 
		)
	Enemies
	)
)

;	sort through enemies unitl they all die or end of level --
;		if current enemy is alive 
;		 yes			
;			is clock running && time > 0  ? 
;			  yes
;				\\wait until time frame is complete
;				;;if time <= 1 
;					;set clock running value false
;				decrease time 
;				execute movement 
;				
;			  no 
;				choose a random time for clock between acceptable times
;				choose a random movement (acceptable speeds)
;				
;		no enemy is dead check for next.

	
(define E-sprite (scale 2 (bitmap/file (build-path ImgDir "P1_tank.png"))))


(define (make-etank E-sprite pos angle pnum)
	//include player class
	(define (make-player sprite pos angle pnum)) 

	(define clockRunning #f) 
	(define time 0)
	(define alive #t) 
	(define health 5)
	(define alert #f)
  
	//Object's Accessor 
	(define (getter mes) 
		(cond 
			((eq? mes 'alive?) alive)  
			((eq? mes 'clockRunning?) clockRunning)
			((eq? mes 'health?) health)  
			((eq? mes 'time?) time)	
			(else mes)
		)
	)
  
	//Object's Mutator
	(define (setter mes) 
		(cond 
			((eq? mes 'die) (set! alive #f))
			((eq? mes 'alive) (set! alive #t))
			((eq? mes 'setTime) setTime)
			((eq? mes 'start) start)
 			((eq? mes 'stop) stop)
			((eq? obj 'damage) (set! damage (- damage 1)))
			(else mes)
	  )
	)  
	
	(define (setTime_speed) 
		(set! time (random 1 5)) ; dont forget to convert clock speeds to seconds
		(set! speed (random 1 10)) ; should choose path directions from player class
	) 
	
	(define (start clock) 
		(set! clockRunning #t)
		(set! time clock) 
	)
 
	(define (stop) 
		(set! clockRunning #f)
		(set! time 0) 
	)
    	
)

(define (CreateEnemies amount)  
	 (if (< amount 1)
	   ()' 
	  (cons (make-etank  E-sprite (cons (random 1 800) (random 1 900)) (random 0 360) 0)  (CreateEnemies (- amount 1) ))
	 )
)

(define (amountOfenemies level)
	(if (= level 0 ) 
		(amountOfenemies 1) 
		(* level 10) 
	)
)