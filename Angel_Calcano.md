# Racket Tanks

## Angel Calcano

### April 30th, 2017

# I. Overview

This program was created to provide one or two players a top-down tank combat game, similar to those styles of arcade games in the mid and late 1980's.

The initial objective on my part was to design enemy object, draw them to the screen,then fire on the good guy if he is in a certain distance.

I thought it was interesting because i had to sit back and think of how things should react over time. 
# Libraries Used

The game uses 2 libraries as follows:

(require 2htdp/image)
(require 2htdp/universe)

- The 2htdp/image library was the primary means of accessing the sprite images that were used for each object on the screen.
- The 2htdp/universe library provides the "engine" behind the game, displaying information that was calculated by each object, regulating the clock that cycles for information output, and controlling the keyboard input to the system.

# Key Code Excerpts

## 1. Enemy class / Object-orientation  

The structure of the enemy class
```racket
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
			((eq? mes 'setTime) setTime_Speed)
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
```
The class inherents the player object, class has mutators and accessors. 
## 2. Creation of Variable Definitions

(define E-sprite (scale 2 (bitmap/file (build-path ImgDir "P1_tank.png"))))

Each tank enemy will have the E-sprite, different enemies in the future will have other sprites loaded. 
## 3. Nested Maps/Filters

With time running out I was not able to finish writing the random movement method for the enemies so I will place pseudocode of how I wanted to work and how I wanted to write it in racket. 
```
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
				#f
			) 
		)
	Enemies
	)
)
```
Map will be used to go through the list of enemy objects if the enemy was dead I would have used rackets filter to clean the object to save memory and time, what took long to design this was trying to come up with a way that was efficient and safe. I wasn't sure if I should of making a global clock and having every enemy class check the global clock to see how much time has passed before setting another random move. I think I might have over complicated this part. For the if statements I was going to use nested conds for the conditions. 

 


  ## 4.  Recursion
  
   I used recursion in creating the list of enemies, iterative recursion will be used in the future to try and save performance. 

 ```racket
 (define (CreateEnemies amount)  
	 (if (< amount 1)
	   ()' 
	  (cons (make-etank  E-sprite (cons (random 1 800) (random 1 900)) (random 0 360) 0)  (CreateEnemies (- amount 1) ))
	 )
)

```

 ##5 presentation link 
     https://www.youtube.com/watch?v=IeLkWO4rtTI&feature=youtu.be
