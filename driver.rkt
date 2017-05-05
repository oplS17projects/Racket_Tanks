#lang racket
(require lang/posn)
(require 2htdp/image)
(require 2htdp/universe)
(require racket_tanks )

;enemy tank 
find good guy() 
	make sure enemy is not in the way 
		get location 
		fire 
		
(define randomMovement( Enemies )  
	(map  
		(lamnda ( bad ) 

		 (if (= (bad   #t) 
			( )
			( )
		 ) 
		)
	Enemies
	)
	sort through enemies unitl they all die or end of level --
		if current enemy is alive 
		 yes			
			is clock running ? 
			  yes
				\\wait until time frame is complete
				if time <= 1 
					set clock running value false
				decrease time 
				execute movement 
				
			  no 
				choose a random time for clock between acceptable times
				choose a random movement (acceptable speeds)
				
		no enemy is dead check for next.
)
	
(define E-sprite (scale 2 (bitmap/file (build-path ImgDir "P1_tank.png"))))


(define (make-etank E-sprite pos angle pnum)
	//include player class
	(define (make-player sprite pos angle pnum)) 

	(define clockRunning #f) 
	(define time 0)
	(define alive #t) 
	(define health 5)
  
	//Object's Accessor 
	(define (getter mes) 
		(cond 
			((eq? mes 'alive?) alive)  
			((eq? mes 'cloclRunning?) update)
			((eq? mes 'health?) alive)  
			((eq? mes 'time?) update)	
		)
	)
  
	//Object's Mutator
	(define (setter mes) 
		(cond 
			((eq? mes 'die) (set! alive #f))
			((eq? mes 'alive) (set! alive #t))
			((eq? mes 'start) (set! clockRunning #t))
 			((eq? mes 'stop) (set! clockRunning #f))
			((eq? obj 'damage) (set! damage (- damage 1)))
	  )
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