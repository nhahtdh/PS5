//
//  GameWolf.h
//  Game
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"

@interface GameWolf : GameObject {
    UIImageView *degreeView;
    UIImageView *arrowView;
    UIImageView *windSuckView;
    
    CGFloat blowingAngle;
    
    UIPanGestureRecognizer *panArrow;
    UITapGestureRecognizer *blowAir;
}

@property (strong, nonatomic, readonly) UIImageView *degreeView;
@property (strong, nonatomic, readonly) UIImageView *arrowView;
@property (strong, nonatomic, readonly) UIImageView *windSuckView;

@property (readonly) CGFloat blowingAngle;

- (void) changeBlowingAngle: (UIPanGestureRecognizer*) gesture;

- (void) blowAir: (UITapGestureRecognizer*) gesture;

@end
