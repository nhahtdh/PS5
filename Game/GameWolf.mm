//
//  GameWolf.m
//  Game
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameWolf.h"

@implementation GameWolf

@synthesize blowingAngle;
@synthesize degreeView;
@synthesize arrowView;
@synthesize windSuckView;
@synthesize powerBar;

-(GameObjectType) kGameObjectType {
    return kGameObjectWolf;
}

- (CGSize) defaultImageSize {
    static const CGSize size = CGSizeMake(225, 150);
    return size;
}

- (CGSize) defaultIconSize {
    static const CGSize size = CGSizeMake(150, 100);
    return size;
}

// TODO: Wolf alive and wolf die
+ (NSArray*) getWolfImages {
    static NSArray* wolfAliveFrames;
    
    if (wolfAliveFrames == nil) {
        wolfAliveFrames = imageToFrames(@"wolfs.png", 5, 3);
    }
    
    return wolfAliveFrames;
}

- (b2BodyDef) bodyDef {
    // REQUIRES: This function should only be called after it is confirmed that the game should start.
    // The object should also be properly inside the game area.
    assert(self.kGameObjectState == kGameObjectStateOnGameArea);
    
    b2BodyDef bodyDef;
    bodyDef.position.Set(pixelToMeter(self.view.center.x), pixelToMeter(self.view.center.y));
    bodyDef.type = b2_dynamicBody;
    bodyDef.angle = self.angle;

    return bodyDef;
}

- (b2FixtureDef) fixtureDef {
    // REQUIRES: This function should only be called after it is confirmed that the game should start.
    // The object should also be properly inside the game area.
    assert(self.kGameObjectState == kGameObjectStateOnGameArea);
    
    b2FixtureDef fixtureDef;
    
    fixtureDef.density = 8;
    fixtureDef.friction = 1.0;
    fixtureDef.restitution = 0.2;
    
    return fixtureDef;
}

- (void) setUpForPlay {
    [super setUpForPlay];
    
    self.arrowView.image = [UIImage imageNamed: @"direction-arrow.png"];
    [self.arrowView sizeToFit];
    self.arrowView.center = CGPointMake(220, 30);
    self.arrowView.transform = CGAffineTransformMakeRotation(M_PI / 2 - DEFAULT_BLOWING_ANGLE);
    self.arrowView.hidden = NO;
    
    blowingAngle = DEFAULT_BLOWING_ANGLE;
    
    self.degreeView.image = [UIImage imageNamed: @"direction-degree.png"];
    [self.degreeView sizeToFit];
    self.degreeView.center = CGPointMake(270, 14);
    self.degreeView.hidden = NO;
    
    moveArrow = [[UIOneFingerRotationGestureRecognizer alloc] initWithTarget: self 
                                                                      action: @selector(changeBlowingAngle:)];
    [moveArrow setDelegate: self];
    // Cannot add gesture recognizer to the subview!!!
    [self.view addGestureRecognizer: moveArrow];
    // [self.view sizeToFit];
    
    blowBreath = [[UILongPressGestureRecognizer alloc] initWithTarget:self action: @selector(blowBreath:)];
    [blowBreath setMinimumPressDuration: 0.5];
    [blowBreath setNumberOfTouchesRequired: 1];
    [blowBreath setDelegate: self];
    [self.view addGestureRecognizer: blowBreath];
    
    self.powerBar.image = [UIImage imageNamed: @"breath-bar.png"];
    [self.powerBar sizeToFit];
    self.powerBar.center = CGPointMake(0, self.imageView.image.size.height / 2);
    self.powerBar.hidden = YES; // Keep it hidden
    
    NSArray *windSuckFrames = imageToFrames(@"windsuck.png", 4, 2);
    CGSize frameSize = ((UIImage*) [windSuckFrames objectAtIndex: 0]).size;
    self.windSuckView.frame = CGRectMake(210, -35, frameSize.width, frameSize.height);
    self.windSuckView.animationImages = windSuckFrames;
    self.windSuckView.hidden = NO;
}

- (void) setUpForBuilder {
    [super setUpForBuilder];
    
    self.arrowView.image = nil;
    self.arrowView.hidden = YES;
    
    self.degreeView.image = nil;
    self.degreeView.hidden = YES;
    
    [self.view removeGestureRecognizer: moveArrow];
    moveArrow = nil;
    
    [self.view removeGestureRecognizer: blowBreath];
    blowBreath = nil;
    
    self.powerBar.image = nil;
    self.powerBar.hidden = YES;
    
    self.windSuckView.image = nil;
    self.windSuckView.animationImages = nil;
    self.windSuckView.hidden = YES;
}

#pragma mark Gestures

-(BOOL) canTranslate {
    return YES;
}

-(BOOL) canRotate {
    return NO;
}

-(BOOL) canZoom {
    return NO;
}

-(void) changeBlowingAngle: (UIOneFingerRotationGestureRecognizer*) gesture {
    // assert(kGameObjectState == kGameObjectStateOnGameArea);
    // assert(gesture.view == self.arrowView);
    
    DLog(@"One finger rotation detected.");
    
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        self.arrowView.image = [UIImage imageNamed: @"direction-arrow-selected.png"];
    }
    
    CGFloat finalAngle = MIN(MAX(self.blowingAngle + [gesture rotation], MIN_BLOWING_ANGLE), MAX_BLOWING_ANGLE);
    CGFloat rotation = self.blowingAngle - finalAngle;
    blowingAngle = finalAngle;
    
    DLog(@"Gesture:%f Real:%f Final:%f", [gesture rotation], rotation, finalAngle);
    
    [self.arrowView setTransform: CGAffineTransformRotate(self.arrowView.transform, rotation)];
    
    if ([gesture state] == UIGestureRecognizerStateEnded ||
        [gesture state] == UIGestureRecognizerStateFailed || 
        [gesture state] == UIGestureRecognizerStateCancelled) {
        self.arrowView.image = [UIImage imageNamed: @"direction-arrow.png"];
    }
}

-(void) blowBreath:(UILongPressGestureRecognizer *)gesture {
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        power = 0.0;
        self.powerBar.hidden = NO;
        powerTimer = [NSTimer scheduledTimerWithTimeInterval: 1 / 60. 
                                                      target: self 
                                                    selector: @selector(variesPower:) 
                                                    userInfo: nil 
                                                     repeats: YES];
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        [powerTimer invalidate];
        powerTimer = nil;
        [self.imageView startAnimating];
        [self.windSuckView startAnimating];
        
        self.powerBar.hidden = YES;
        // self.windSuckView.hidden = YES;
    } else if ([gesture state] == UIGestureRecognizerStateCancelled) {
        DLog(@"WARNING: Gesture cancelled on %@", self);
        [powerTimer invalidate];
        powerTimer = nil;
        self.powerBar.hidden = YES;
    }
}

- (void) variesPower: (NSTimer*) timer {
    
}

#pragma mark - View life cycle

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self.view setAutoresizesSubviews: YES];
    [self.view setBackgroundColor: [UIColor clearColor]];

    // Set up the wolf image view
    UIImage *wolfImage = [[GameWolf getWolfImages] objectAtIndex: 0];
    imageView = [[UIImageView alloc] initWithImage: wolfImage];
    
    self.imageView.animationImages = [GameWolf getWolfImages];
    self.imageView.animationRepeatCount = 1;
    self.imageView.animationDuration = BLOWING_TIME;
    
    [self.view addSubview: self.imageView];
    
    // Set up the direction degree
    degreeView = [[UIImageView alloc] init];
    self.degreeView.hidden = YES;
    
    [self.view addSubview: self.degreeView];
    
    // Set up image view for the arrow
    arrowView = [[UIImageView alloc] init];
    self.arrowView.hidden = YES;
    
    [self.view addSubview: self.arrowView];
    
    // Set up image view for power bar
    powerBar = [[UIImageView alloc] init];
    self.powerBar.hidden = YES;
    
    [self.view addSubview: self.powerBar];
    
    // Set up image view for wind sucking
    windSuckView = [[UIImageView alloc] init];
    self.windSuckView.animationRepeatCount = 1;
    self.windSuckView.animationDuration = BLOWING_TIME;
    self.windSuckView.hidden = YES;
    
    [self.view addSubview: self.windSuckView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    // TODO: Not too sure about these
    imageView = nil;
    degreeView = nil;
    arrowView = nil;
    windSuckView = nil;
}

@end
