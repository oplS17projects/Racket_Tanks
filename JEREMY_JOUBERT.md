# Racket Tanks

## Jeremy Joubert

### April 30th, 2017

# I. Overview

This program was created to provide one or two players a top-down tank combat game, similar to those styles of arcade games in the mid and late 1980's.

Key to this was that each element to the game was able to be created as an object, allowing it to be manipulated via lists, maps, and filters, such that the code was as simple as possible to understand.

The initial object is the world in which the game was running, which itself comprised three sub-objects, those being the title screen, controls screen, and play screen.
Within those screens were their various elements, the most complex of which was (of course) the play screen, which consisted of background, player tanks, and projectiles, as well as was intended to have enemies, health bars, and scores.

# Libraries Used

The game uses 3 libraries as follows:

(require lang/posn)
(require 2htdp/image)
(require 2htdp/universe)

- The lang/posn library provides the means to translate the positions of objects into x/y coordinates thereby providing the means to calculate movement and rotation of objects
- The 2htdp/image library was the primary means of accessing the sprite images that were used for each object on the screen.
- The 2htdp/universe library provides the "engine" behind the game, displaying information that was calculated by each object, regulating the clock that cycles for information output, and controlling the keyboard input to the system.

# Key Code Excerpts

### Note - Unless otherwise stated, all code samples below were authored by me.

## 1. Output Title Screen

The code below defines the game screen that outputs the background, text and selectors for the title screen.
The selector objects are implemented to be moved up/down/left/right accordingly and update the game settings when this is done.

```racket
(define (game-scrn)
  (place-images (list splash-txt
                      controls-txt
                      players-txt
                      playerssel-txt
                      attack-txt
                      np_selector
                      gm_selector)
                (list (make-posn 720 300)
                      (make-posn 720 475)
                      (make-posn 720 575)
                      (make-posn 720 650)
                      (make-posn 720 750)
                      (player-selector-posn)
                      (window-selection))
                splash-img))
```
One of the things the course outlined carefully was proper use of lists, which in this case compromise the two halves of this procedures input. Each object in the first list must properly correspond the an object in the second list, each of these consisting of a pair of values used to create a set of coordinates. Improper use of lists here would cause game errors, inability to launch the game, and more.

## 2. Creation of Variable Definitions

The code below is just a few of the define functions that were used in this program to simplify use of many of the objects that were a part of it. Each define gave an element of the game a name that would in turn call upon the creation and initial design of each.

```racket
(define splash-txt (bitmap/file (build-path ImgDir "Title_text.png")))
(define players-txt (scale .5 (bitmap/file (build-path ImgDir "NP_1text.png"))))
(define playerssel-txt (scale .35 (bitmap/file (build-path ImgDir "NP_2text.png"))))
(define attack-txt (scale .5 (bitmap/file (build-path ImgDir "Attack_text.png"))))
(define controls-txt (scale .5 (bitmap/file (build-path ImgDir "Controls_text.png"))))
(define acc-txt (scale .3 (bitmap/file (build-path ImgDir "Accel_text.png"))))
```

Probably one of the biggest take aways from this course for me was learning how to design effective "define" objects, as this carries through the rest of the program design by not only making each object more easy to call upon, but also by making the code less verbose and removing chances for errors throughout the code. Rather than hunting through every instance of a function call for an object, if there is an issue, the define is the only place that need be checked for issues in order to fix it throughout the program.

## 3. Object Creations

The single largest aspect of the program is the creation of various objects. Each having many aspects in common with others, it proved a better idea to provide a generic class-style object from which others would then be created. In the case of the code below, it was the basis for ALL objects, being that it was the generic entity object creator. All entities would have some type of sprite, would need to be defined as solid for purposes of collisions, would need a position, orientation, and owner number.

```racket
(define (make-entity sprite solid pos dir pnum)
  (define (set-spr angle) (set! sprite (rotate angle sprite)))
  (define (set-x xpos) (set! pos (cons xpos (cdr pos))))
  (define (set-y ypos) (set! pos (cons (car pos) ypos)))
  (define (set-dir angle) (set! dir angle))
  (define active #t)
  (define (destroy) (set! active #f))
  
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
          ((eq? obj 'intact?) active)
          ((eq? obj 'destroy) (set! active #f))
          ((eq? obj 'solid) solid)
          ((eq? obj 'pnum) pnum)
          (else (begin (print "Unknown value") obj))))
  (set! player-tanks (append player-tanks (list dispatch)))  
  dispatch)
  ```
  
  Each of the elements of the entity were in turn defined for use within the game world, which provided what I feel to be a small version of a metacircular evaluator. Additonally, at the bottom of the dispatch fuction, which is how each aspect of the entity is updated, another form of list maniuplation is asserted in the form of appending a list and using set! to ensure that all previous objects are included. The improtance of this will be shown later.
  
  ## 4. Mapping Collisions
  
  As stated in the previous entry, appending the list of object created mattered for this portion of the code. In the code below, objects on the screen are compared to others to determine if collisions have taken place, and in turn, calls the appropriate functions to destroy each.
  
 ```racket
 (define (check-collisions)
  ;;check if the collidable hit the player
  (map (λ (tank)
         (map (λ (bullet) (if (collide tank bullet)
                              (begin (bullet 'destroy) (tank 'destroy))
                              #f)) projectiles)) player-tanks))
```
This code works by mapping each player object to each projectile, with the player objects, in turn being mapped to a function that checks for a collision based on the size of each object's sprite. If the function finds that a collision has tanken place, it calls on each objects destroy function to remove it from their respective list, or otherwise returns false and continues through each loop. This allows for swift checking of collisions between all objects by creating a map within a map.

## 5. Clean-up Extraneous Objects

The last key piece of code I want to point out is that extraneous objects, projectiles in particular, are cleaned up so as to free any memory that is not needed to be used. The following code implements this by calling the destroy function on any objects that are beyond the edges of the screen, and then filtering those objects from being updated any further by the system.

```racket
(define objs-pos (map (λ (entity) (make-posn (entity 'x) (entity 'y))) (filter active? player-tanks)))
(define objs-sprites (map (λ (entity) (entity 'sprite)) (filter active? player-tanks)))
(define screen '())
```

By using filter in this way, the game rendering function is then able to filter out inactive objects from being updated and wasting resources to monitor these objects. It also causes these objects to not be "displayed" off the screen as this is unneccesary once an object has left it.