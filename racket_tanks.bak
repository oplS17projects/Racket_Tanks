#lang racket
(require lang/posn)
(require 2htdp/image)
(require 2htdp/universe)

; As with previous file, images for the background and tank will be needed here
; to practice with manipulating and animating the resulting images. The
; functions below are for this task.

; Create a relative path to current image folder
(define ImgDir (build-path (current-directory) "GameImgs"))

; Define the image to be used for the background
(define Background (bitmap/file (build-path ImgDir "Battlefield1.png")))

; Define the variables based on the size of the play screen
(define WIDTH (image-width Background))
(define HEIGHT (image-height Background))

;; Initial tank speed
(define Tank_Spd 0)

;; A Tank is a (make-tank Posn Number Number)
(define-struct tank (posn speed angle))

;; A World is a (make-world player)
(define-struct world (player1))

;; Takes an angle in degrees and returns a directional Posn
;;   Accounts for the downward-increasing Y-axis of scenes/images
;;   by multiplying the posn-y by -1
(define (angle->posn a)
  (make-posn (inexact->exact (round (cos (* a pi 1/180))))
             (* -1 (inexact->exact (round (sin (* a pi 1/180)))))))

;; Adds two Posns together.
(define (add-posns a b)
  (make-posn (modulo (+ (posn-x a) (posn-x b)) WIDTH)
             (modulo (+ (posn-y a) (posn-y b)) HEIGHT)))

;; Multiplies a Posn by a given number.
(define (posn* p n)
  (make-posn (modulo (* (posn-x p) n) WIDTH)
             (modulo (* (posn-y p) n) HEIGHT)))

;; Checks if two posns are equal.
(define (posn=? a b)
  (and (= (posn-x a) (posn-x b))
       (= (posn-y a) (posn-y b))))

;; Rotates tank within the world.
(define (turn deg w)
  (make-world (make-tank (tank-posn (world-player1 w))
                         (tank-speed (world-player1 w))
                         (modulo (+ deg (tank-angle (world-player1 w))) 360))))

;; Increases the tank speed factor
(define (accelerate w)
  (make-world (make-tank (tank-posn (world-player1 w))
                         (if (>= 7 (tank-speed (world-player1 w)))
                             (+ 7 (tank-speed (world-player1 w)))
                             (+ 0 (tank-speed (world-player1 w))))
                         (tank-angle (world-player1 w)))))

;; Moves the tank forward in the direction faced
(define (move-tank t)
  (make-tank (add-posns (tank-posn t)
                        (posn* (angle->posn (tank-angle t))
                               (tank-speed t)))
             (cond ((zero? (tank-speed t)) 0)
                   ((> (tank-speed t) 0) (- (tank-speed t) 1))
                   (else (+ (tank-speed t) 1)))
             (tank-angle t)))

;; Takes a world, moves the tank.
(define (tock w)
  (make-world (move-tank (world-player1 w))))
  
;; Controls:
;; - up/w     move forward
;; - left/a   turn left
;; - right/d  turn right
(define (key-handler w k)
  (cond
    [(or (key=? k "w") (key=? k "up")) (accelerate w)]
    [(or (key=? k "a") (key=? k "left"))  (turn  45 w)]
    [(or (key=? k "d") (key=? k "right")) (turn -45 w)]
    [else w]))

;; The tank image file
(define Tank_Img
  (rotate
   90
   (bitmap/file (build-path ImgDir "playertank.png"))))

;; Places a tank onto a scene.
(define (place-player player scene)
  (place-image (rotate (tank-angle player) Tank_Img)
               (posn-x (tank-posn player))
               (posn-y (tank-posn player))
               scene))

;; Draws the world
(define (display w)
  (place-player (world-player1 w)
                Background))

;; Starting world
(define gameworld (make-world (make-tank (make-posn (* WIDTH 0.5)
                                                    (* HEIGHT 0.6))
                                         Tank_Spd
                                         0)))
;; Initialize gameworld interface
(big-bang gameworld
          (on-tick tock)
          (on-key key-handler)
          (on-draw display)
          (state false))