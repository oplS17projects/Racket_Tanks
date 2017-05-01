# Racket Tanks

## Angel Calcano

### April 30th, 2017

# I. Overview

This program was created to provide one or two players a top-down tank combat game, similar to those styles of arcade games in the mid and late 1980's.

The initial objective on my part was to design enemy object, draw them to the screen,then fire on the good guy if he is in a certain distance.

I thought it was interesting because i had to sit back and think of how things should react over time. 
# Libraries Used

The game uses 3 libraries as follows:

(require 2htdp/image)
(require 2htdp/universe)

- The 2htdp/image library was the primary means of accessing the sprite images that were used for each object on the screen.
- The 2htdp/universe library provides the "engine" behind the game, displaying information that was calculated by each object, regulating the clock that cycles for information output, and controlling the keyboard input to the system.

# Key Code Excerpts

## 1. Enemy class / Object-orientation  

The structure of the enemy class
```racket
(define (make-etank pos angle pnum)

  (define tank (make-entity (rotate angle sprite) #t pos angle pnum))
  (define speed 0)
  (define trn-spd 10)
  (define spd-up #f)
  (define slw-dwn #f)
  (define trn-l #f)
  (define trn-r #f)
  (define clockRunning #f) 
  (define time 0)
  (define alive #t) 
  (define health 5) 

  ;; taken from player class 
  (define (move-tank)
    (define (inbounds x y)
      (cond ((< x 0) (set! x (+ x WIDTH)))
            ((> x WIDTH) (set! x (- x WIDTH))))
      (cond ((< y 0) (set! y (+ y HEIGHT)))
            ((> y HEIGHT) (set! y (- y HEIGHT))))
      ((tank 'set-x) x)
      ((tank 'set-y) y))
    (inbounds (inexact->exact (round (+ (tank 'x)
                                        (* speed (cos (deg-to-rad (tank 'dir)))))))
              (inexact->exact (round (+ (tank 'y)
                                        (* speed (sin (deg-to-rad (tank 'dir)))))))))
  
  (define (accelerate)
    (cond ((< speed 10) (set! speed (+ speed 1))))
    (move-tank))
    

  (define (decelerate)
    (cond ((> speed -10) (set! speed (- speed 1))))
    (move-tank))
  
  (define (coast)
    (cond ((< speed 0) (set! speed (+ speed 1)))
          ((> speed 0) (set! speed (- speed 1))))
    (move-tank))

  (define (turn-right)
    (if (> (+ (tank 'dir) trn-spd) 360)
        ((tank 'set-dir) (- (+ (tank 'dir) trn-spd) 360))
        ((tank 'set-dir) (+ (tank 'dir) trn-spd)))
    ((tank 'set-spr) (* -1 trn-spd)))

  (define (turn-left)
      (if (< (- (tank 'dir) trn-spd) 0)
        ((tank 'set-dir) (+ (- (tank 'dir) trn-spd) 360))
        ((tank 'set-dir) (- (tank 'dir) trn-spd)))
    ((tank 'set-spr) trn-spd))

  (define (shoot)
    (set! projectiles (append projectiles (list (make-projectile (tank 'pnum))))))  
  
  (define (update)
    (cond ((and spd-up (not slw-dwn)) (accelerate))
          ((and (not spd-up) slw-dwn) (decelerate))
          ((and (not spd-up) (not slw-dwn)) (coast)))
    (cond ((and trn-l (not trn-r)) (turn-left))
          ((and (not trn-l) trn-r) (turn-right))))

  (define (dispatch obj)
    (cond ((eq? obj 'update) update)      
          ((eq? obj 'spd-up) (set! spd-up #t) (set! slw-dwn #f))
          ((eq? obj 'slw-dwn) (set! spd-up #f) (set! slw-dwn #t))
          ((eq? obj 'coast) (set! spd-up #f) (set! slw-dwn #f))
          ((eq? obj 'turn-left) (set! trn-l #t) (set! trn-r #f))
          ((eq? obj 'turn-right) (set! trn-l #f) (set! trn-r #t))
          ((eq? obj 'stop-turn)  (set! trn-l #f) (set! trn-r #f))
          ((eq? obj 'fire) (begin (shoot)))
          (else (tank obj))))
  dispatch)
   
 ) 
```
I included some of the movement code from the player class because I did not know how to inherit from other objects in racket so this was a sloppy brute force way in doing so. The code would have been a lot cleaner if I was able to .A random function was going to influence the movement over time. 
## 2. Creation of Variable Definitions

(define E-sprite (scale 2 (bitmap/file (build-path ImgDir "P1_tank.png"))))

Each tank enemy will have the E-sprite, different enemies in the future will have other sprites loaded. 
## 3. Nested Maps/Filters

With time running out I was not able to finish writing the random movement method for the enemies so I will place pseudocode of how I wanted to work and how I wanted to write it in racket. 
```
sort through enemies until they all die or end of level --
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
```
I was going to use nested maps to go through the list of enemy objects if the enemy was dead I would have used rackets filter to clean the object to save memory and time, what took long to design this was trying to come up with a way that was efficient and safe. I wasn't sure if I should of making a global clock and having every enemy class check the global clock to see how much time has passed before setting another random move. I think I might have over complicated this part. For the if statements I was going to use nested conds for the conditions. 

 


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

