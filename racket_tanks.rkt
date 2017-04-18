#lang racket
(require lang/posn)
(require 2htdp/image)
(require 2htdp/universe)

; As with previous file, images for the background and tank will be needed here
; to practice with manipulating and animating the resulting images. The
; functions below are for this task.

;; Game values

; Create a relative path to current image folder
(define ImgDir (build-path (current-directory) "GameImgs"))

; Define game resources
(define background (bitmap/file (build-path ImgDir "Battlefield1.png")))
(define player1-sprite
  (scale 2 (bitmap/file (build-path ImgDir "player1tank.png"))))
(define player2-sprite
  (scale 2 (bitmap/file (build-path ImgDir "player2tank.png"))))
(define bullet-sprite
  (scale 2 (bitmap/file (build-path ImgDir "shot.png"))))

; Define the variables based on the size of the play screen
(define WIDTH 1440)
(define HEIGHT 900)

; General functions
(define (deg-to-rad x)
  (inexact->exact (* x (/ pi 180))))

;define game entities
(define projectiles '())
(define player-tanks '())

;;Entity constructor
; Sprite - image used for a particular object
; Solid - Solid objects are able to be impacted
; Pos - X/Y coords of object
; Dir - Angle (in degrees) of object
; Pnum - Owner number, 1 = Player1, 2 = Player2, 0 = N/A
(define (make-entity sprite solid pos dir pnum)
  (define (set-spr angle) (set! sprite (rotate angle sprite)))
  (define (set-x xpos) (set! pos (cons xpos (cdr pos))))
  (define (set-y ypos) (set! pos (cons (car pos) ypos)))
  (define (set-dir angle) (set! dir angle))
  (define intact #t)
  (define (destroy) (set! intact #f))

  (define (dispatch obj)
    (cond ((eq? obj 'sprite) sprite)
          ((eq? obj 'set-spr) set-spr)
          ((eq? obj 'w) (image-width sprite))
          ((eq? obj 'h) (image-height sprite))
          ((eq? obj 'x) (car pos))
          ((eq? obj 'y) (cdr pos))
          ((eq? obj 'pos) pos)
          ((eq? obj 'set-x) set-x)
          ((eq? obj 'set-y) set-y)
          ((eq? obj 'dir) dir)
          ((eq? obj 'set-dir) set-dir)
          ((eq? obj 'intact?) intact)
          ((eq? obj 'destroy) (set! intact #f))
          ((eq? obj 'solid) solid)
          ((eq? obj 'pnum) pnum)
          (else (begin (print "Unknown value") obj))))
  (set! player-tanks (append player-tanks (list dispatch)))  
  dispatch)

;;Player Class

(define (make-player sprite pos angle pnum)
  (define tank (make-entity (rotate angle sprite) #t pos angle pnum))
  (define speed 0)
  (define trn-spd 10)
  (define spd-up #f)
  (define slw-dwn #f)
  (define trn-l #f)
  (define trn-r #f)
  
;; Movement procedures (updates sprite accordingly)

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

;; Create Player objects
(define player1 (make-player player1-sprite (cons 360 450) 0 1))
(define player2 (make-player player2-sprite (cons 1080 450) 180 2))

;; Projectile Class
(define (make-projectile owner)
  (define pos (cons 0 0))
  (define angle 0)
  (if (= owner 1)
      (begin (set! pos (cons (player1 'x) (player1 'y)))
             (set! angle (player1 'dir)))
      (begin (set! pos (cons (player2 'x) (player2 'y)))
             (set! angle (player2 'dir))))
  (define speed 20)
  (define bullet (make-entity (rotate angle bullet-sprite) #t pos angle owner))

;; Movement Procedures for Projectiles

  (define (move-bullet)
    ((bullet 'set-x) (inexact->exact (round (+ (bullet 'x)
                                               (* speed (cos (deg-to-rad (bullet 'dir))))))))
    ((bullet 'set-y) (inexact->exact (round (+ (bullet 'y)
                                               (* speed (sin (deg-to-rad (bullet 'dir)))))))))
  (define (dispatch x)
    (cond ((eq? x 'update) (move-bullet))
          (else (bullet x))))

  dispatch)

;; Determine if an object is still active or is destroyed
(define (active? obj)
  (eq? (obj 'intact?) #t))

;; Determine if a given object is on screen
(define (inbounds object)
  (if (or (< (object 'x) WIDTH)
          (> (object 'x) 0)
          (< (object 'y) HEIGHT)
          (> (object 'y) 0))
      #t
      #f))

;; Define collision detection
(define (collide obj1 obj2)
  (define o1 (obj1 'pnum))
  (define x1 (obj1 'x))
  (define y1 (obj1 'y))
  (define w1 (obj1 'w))
  (define h1 (obj1 'h))
  (define o2 (obj2 'pnum))
  (define x2 (obj2 'x))
  (define y2 (obj2 'y))
  (define w2 (obj2 'w))
  (define h2 (obj2 'h))
  (if (and (not (= o1 o2)) (< x1 (+ x2 w2)) (< x2 (+ x1 w1)) (< y2 (+ y1 h1)) (< y1 (+ y2 h2)))
      #t
      #f))

(define (check-collisions)
  ;;check if the collidable hit the player
  (map (λ (tank)
         (map (λ (bullet) (if (collide tank bullet)
                              (begin (bullet 'destroy) (tank 'destroy))
                              #f)) projectiles)) player-tanks))                        

;; Clean up destroyed objects and objects off screen
(define (clean-up)
  (map (λ (tank) (if (not (active? tank))
                     (remove tank player-tanks)
                     #f)) player-tanks)
  (map (λ (bullet) (if (or (not (active? bullet)) (inbounds bullet))
                       (remove bullet projectiles)
                       #f)) projectiles))

;; Update screen
(define ticks 0)
(define seconds 1)
(define game-over #f)

(define (update dt)
  (begin
    ((player1 'update))
    ((player2 'update))
    (map (λ (bullet) (bullet 'update)) projectiles)
    (set! ticks (+ 1 ticks))
    (set! seconds (+ 1/28 seconds))
    (check-collisions))
  (clean-up))
    
(define (handle-key-press wrld key)
  (cond
    [(key=? key "w")(player1 'spd-up)]
    [(key=? key "s") (player1 'slw-dwn)]
    [else wrld])
  (cond
    [(key=? key "up") (player2 'spd-up)]
    [(key=? key "down") (player2 'slw-dwn)]
    [else wrld])
  (cond
    [(key=? key "a") (player1 'turn-left)]
    [(key=? key "d") (player1 'turn-right)]
    [else wrld])
  (cond
    [(key=? key "left") (player2 'turn-left)]
    [(key=? key "right") (player2 'turn-right)]
    [else wrld])
  (cond
    [(key=? key " ") (player1 'fire)])
  (cond
    [(key=? key "\r") (player2 'fire)])
  )

(define (handle-key-release wrld key)
  (cond
    [(key=? key "w")(player1 'coast)]
    [(key=? key "s") (player1 'coast)]
    [else wrld])
  (cond
    [(key=? key "up") (player2 'coast)]
    [(key=? key "down") (player2 'coast)]
    [else wrld])
  (cond
    [(key=? key "a") (player1 'stop-turn)]
    [(key=? key "d") (player1 'stop-turn)]
    [else wrld])
  (cond
    [(key=? key "left") (player2 'stop-turn)]
    [(key=? key "right") (player2 'stop-turn)]
    [else wrld])
  )

;; Rendering Initialization
(define objs-pos (map (λ (entity) (make-posn (entity 'x) (entity 'y))) (filter active? player-tanks)))
(define objs-sprites (map (λ (entity) (entity 'sprite)) (filter active? player-tanks)))
(define screen '())

(define (rendergame x)
  (set! objs-pos (map (λ (entity) (make-posn (entity 'x) (entity 'y))) (filter active? player-tanks)))
  (set! objs-sprites (map (λ (entity) (entity 'sprite)) (filter active? player-tanks)))
  (set! screen (place-images objs-sprites objs-pos background))
  screen)


(define (game-start)
  (begin (big-bang 0
                   (on-tick update)
                   (on-key handle-key-press)
                   (on-release handle-key-release)
                   (to-draw rendergame))))

;; Render Start Screen Interface
(define start-text (text "Press [space] to start" 24 "white"))
(define titlescrn (overlay (bitmap/file (build-path ImgDir "Title_Text.png")) (bitmap/file (build-path ImgDir "Title_Splash.jpg"))))

(define (change wrld key)
  (cond ((key=? key " ") (game-start))
        (else wrld)))

(define (rendertitle x)
  (underlay/xy titlescrn 600 820 start-text))

(big-bang 0
          (on-key change)
          (to-draw rendertitle))  