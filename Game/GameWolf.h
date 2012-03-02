//
//  GameWolf.h
//  Game
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"
#import "UIOneFingerRotationGestureRecognizer.h"

// When the arror is at horizontal position, the angle is 0
#define MAX_BLOWING_ANGLE (M_PI / 2)
#define MIN_BLOWING_ANGLE (-M_PI / 3)
#define DEFAULT_BLOWING_ANGLE (M_PI / 3)

// The time for the wolf to release the breath
#define BLOWING_TIME (1.)

@interface GameWolf : GameObject {
    UIImageView *degreeView;
    UIImageView *arrowView;
    UIImageView *windSuckView;
    UIImageView *powerBar;
    NSTimer *powerTimer;
    
    CGFloat blowingAngle;
    CGFloat power;
    
    UIOneFingerRotationGestureRecognizer *moveArrow;
    UILongPressGestureRecognizer *blowBreath;
}

@property (strong, nonatomic, readonly) UIImageView *degreeView;
@property (strong, nonatomic, readonly) UIImageView *arrowView;
@property (strong, nonatomic, readonly) UIImageView *windSuckView;
@property (strong, nonatomic, readonly) UIImageView *powerBar;

@property (readonly) CGFloat blowingAngle;

- (void) setUpForPlay;

- (void) setUpForBuilder;

// - (void) variesPower: (NSTimer*) timer;

- (void) changeBlowingAngle: (UIOneFingerRotationGestureRecognizer*) gesture;

- (void) blowBreath: (UITapGestureRecognizer*) gesture;

@end
