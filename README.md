# Racket Tanks

### Statement
A classic top-down shooting game which will  use recursion, filtering, object orientation, and other techniques to control the action.

### Analysis
Below is an outline of the various techniques that will be implemented in the design of the game:

-Data Abstraction: Data will be abstracted into basic objects with similar factors, i.e. dimensions, speed, location, active status, and so on. This will allow objects like tanks, bullets, and enemies to be handled similarly.
- Filtering: As objects are created, and destroyed, it will be necessary to ensure that objects that are no longer necessary are removed. This is one excellent way to use a filter to ensure that extraneous objects are deleted.
-Recursion: Updating the location information, and status of each of the objects will be most easily handled with recursive functions that will go through their relevant lists.
-Expression evaluation: As each of the objects move around the screen, their various maneuvers and collisions will be calculated using expression evaluation to determine changes.


### Data Sets or other Source Materials

Source Materials:

Many of the objects that will be used in this game come from pre-existing images, namely sprites, that are commonplace around the Internet. This approach is to allow for a maximum amount of customizability to the game oddly enough, as using these will allow a player to select from various battlefields, tanks, and going forward, potentially different weapons, and enemies.

Credit due to the following creators of content used:

Tank sprites courtesy of user Zironid_n at www.freegameart.org

### Deliverable and Demonstration

Our goal is to ultimately deliver a game that will be able to be demonstrated, and enjoyed well after this semester comes to a close. In terms of detail, we hope the game will permit one or two players to play against each other or the computer individually or cooperatively. This will is to all be determined by a menu that will launch when the game is first run. 

### Evaluation of Results

Needless to say, a smooth game experience is the base requirement for this, and that will be a success. This entails the game not only playing correctly, but the menu functionality, scoring, and enemy action to correctly work, as well as all relative paths to external mediums, such that the game can be moved to a different system and still be played.

## Architecture Diagram

Section under Construction!

## Schedule
### First Milestone (Sun Apr 9)
Jeremy's Objectives:
Core algorithms for file access, movement vectors, collisions, and object interactions should be in place. 

### Second Milestone (Sun Apr 16)
Jeremy's Objectives:
Any remaining additons to keyboard commands should be functional, and collisions between terrrain, tanks, bullets, and enemies should be handled. Additional keyboard commands to control the menu should be in place. 

### Public Presentation (Mon Apr 24, Wed Apr 26, or Fri Apr 28 [your date to be determined later])
Jeremy's Objectives:
Full game interface should be functional. Additional functions for other objects, possibly adding in aircraft, pickups, and interactive terrain, though, the primary goal should be a fully functional game.

## Group Responsibilities
### Jeremy Joubert @joubs8783
will write the code centered on file loading, object control, and collisions.
I will be responsible for ensuring that files that are needed are able to be properly loaded, keyboard inputs funtioning as intended, and collisions resulting in the proper object(s) being destroyed and players being awarded points/losing lives as needed. This list may grow as time moves forward, but this is the current expectation.

### Leonard Lambda @lennylambda
will work on...