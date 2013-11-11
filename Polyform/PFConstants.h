//
//  PFConstants.h
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

// physiscs constants
#define DEFAULT_DENSITY (1.0f)
#define DEFAULT_RESTITUTION (0.0f)
#define DEFAULT_FRICTION (1.0f)
#define GRAVITY (20.0f) // m/s/s
#define TIMESTEP (0.01f) // s
#define FRAMERATE (60.0f) // f/s
#define VELOCITY_ITERTATIONS (8)
#define POSITION_ITERATIONS (3)
#define CONTINUOUS_PHYSICS (YES)
#define ALLOW_SLEEPING (NO)

// geomtric constants
#define TBASE (1.0f) // triangle base (2/sqrt(3))
#define THEIGHT (0.86602540378444f) // triangle height (sqrt(3)/2)
#define TRAD (0.3333333333333333f) // triangle inner radius (1/3)
#define RRAD (0.5f) // circle radius
#define RSTACK (0.86602540378444f) // circle stack spacing (sqrt(3)/2)
#define MAX_BRICK_RADIUS (2.08585713796511) // m
#define SPAWN_START_RADIUS (0.5f) // m
#define SPAWN_END_RADIUS (2.5f) // m

// game constants
#define MAX_BRICK_COUNT (100)
#define MAX_SEGMENT_COUNT (400)
#define BRICK_SPAWN_HEIGHT (15.0f) // m
#define BRICK_LET_LOOSE_DEPTH (2.0f) // m below zero line
#define BRICK_DESTRUCTION_DEPTH (4.0f) // m below zero line
#define COLOR_GROUPS (7)
#define SPAWN_LOOP_LENGTH (180) // frames
#define HINT_TIMER_LENGTH (60) // frames
#define SPAWN_TIMER_LENGTH (30) // frames
#define DROP_START_COUNT (99) // 0 or more
#define TEXT_75_FONT (@"HelveticaNeue-UltraLight")
#define TEXT_22_FONT (@"HelveticaNeue-Light")
#define TEXT_16_FONT (@"HelveticaNeue")
#define TEXT_12_FONT (@"HelveticaNeue-Medium")
#define TEXT_75_POINT (75.00f)
#define TEXT_22_POINT (22.07f)
#define TEXT_16_POINT (15.80f)
#define TEXT_12_POINT (12.00f)

// base constants
#define WELL_FADE_WIDTH (-1.0f)

// brick constants
#define OUTLINE_OFFSET (0.05f) // m
#define INLINE_OFFSET (-0.05f) // m
#define HOVER_GRAVITY_SCALE (0.5f) // 0 - infinity
#define HOVER_LINEAR_DAMPING (5.0f) // box2d?
#define HOVER_ANGULAR_DAMPING (5.0f) // box2d?
#define DRAG_ANGULAR_DAMPING (5.0f) // box2d?
#define ROTATE_LINEAR_DAMPING (20.0f) // box2d?
#define STABILITY_VEL_SQ (1.0f) // m/s/s squared
#define STABILITY_ANG_VEL (1.0f) // rad/s/s squared
#define STABILITY_TIMER (30) // frames

// scan constants
#define SCAN_HALF_RANGE (0.45f) // m
#define SCAN_OVERLAP_COUNT (9) // segments
#define SCAN_OVERLAP_TIMER (10) // frames
#define SCAN_DESTRUCTION_FUSE (10) //frames

// level menu constants
#define TANK_WIDTH (16.0f) // m
#define TANK_HEIGHT (16.0f) // m
#define TANK_BOTTOM (-4.0f) // m
#define TANK_SPACING (20.2f) // m

// opengl rendering constants
#define LAUNCH_ANIMATION_DELAY (2) // frames
#define LAUNCH_SCREEN_SPAN_FOR_COLOR (40.0f) // m should be 40 probably
#define SCENE_TRANSITION_BRIGHTNESS_STEP (0.1f) // 0 - 1

// audio constants
#define FRAMES_PER_LOOP (480)