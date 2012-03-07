//
//  GameWolf.m
//  Game
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameWolf.h"
#import "GameViewController.h"

@implementation GameWolf

@synthesize power;
@synthesize blowingAngle;

@synthesize degreeView;
@synthesize arrowView;
@synthesize windSuckView;
@synthesize powerBar;
@synthesize staticPowerBar;

-(GameObjectType) kGameObjectType {
    return kGameObjectWolf;
}

- (CGSize) defaultImageSize {
    return CGSizeMake(225, 150);
}

- (CGSize) defaultIconSize {
    return CGSizeMake(150, 100);
}

// TODO: Wolf alive and wolf die
+ (NSArray*) getWolfImages {
    static NSArray* wolfAliveFrames;
    
    if (wolfAliveFrames == nil) {
        wolfAliveFrames = imageToFrames(@"wolfs.png", 5, 3);
    }
    
    return wolfAliveFrames;
}

- (b2Shape*) shape {
    // REQUIRES: This function should only be called after it is confirmed that the game should start.
    // The object should also be properly inside the game area.
    assert(self.kGameObjectState == kGameObjectStateOnGameArea);
    
    b2PolygonShape *shape = new b2PolygonShape();
    shape->SetAsBox(pixelToMeter(self.scale * self.defaultImageSize.width) / 2., 
                    pixelToMeter(self.scale * self.defaultImageSize.height) / 2.);
    
    return shape;
}

- (b2FixtureDef) fixtureDef {
    // REQUIRES: This function should only be called after it is confirmed that the game should start.
    // The object should also be properly inside the game area.
    assert(self.kGameObjectState == kGameObjectStateOnGameArea);
    
    b2FixtureDef fixtureDef;
    
    fixtureDef.density = 4;
    fixtureDef.friction = 1.0;
    fixtureDef.restitution = 0.1;
    
    return fixtureDef;
}

- (void) setUpForPlay {
    [super setUpForPlay];
    
    self.imageView.animationImages = [GameWolf getWolfImages];
    
    self.arrowView.image = [UIImage imageNamed: @"direction-arrow.png"];
    [self.arrowView sizeToFit];
    self.arrowView.center = [self.view convertPoint: CGPointMake(220, 30) toView: self.view.superview];
    self.arrowView.transform = CGAffineTransformMakeRotation(M_PI / 2 - DEFAULT_BLOWING_ANGLE);
    self.arrowView.hidden = NO;
    [self.view.superview insertSubview: self.arrowView belowSubview: self.view];
    
    blowingAngle = DEFAULT_BLOWING_ANGLE;
    
    self.degreeView.image = [UIImage imageNamed: @"direction-degree.png"];
    [self.degreeView sizeToFit];
    self.degreeView.center = CGPointMake(270, 14);
    self.degreeView.hidden = NO;
    
    moveArrow = [[UIOneFingerRotationGestureRecognizer alloc] initWithTarget: self 
                                                                      action: @selector(changeBlowingAngle:)];
    [moveArrow setDelegate: self];
    [self.arrowView addGestureRecognizer: moveArrow];
    
    blowBreath = [[UILongPressGestureRecognizer alloc] initWithTarget:self action: @selector(blowBreath:)];
    [blowBreath setMinimumPressDuration: 0.5];
    [blowBreath setNumberOfTouchesRequired: 1];
    [blowBreath setDelegate: self];
    [self.imageView addGestureRecognizer: blowBreath];
    
    UIImage *breathBarImage = [UIImage imageNamed: @"breath-bar.png"];
    self.powerBar.image = breathBarImage;
    [self.powerBar sizeToFit];
    self.powerBar.center = CGPointMake(0, self.imageView.image.size.height / 2);
    self.powerBar.hidden = YES; // Keep it hidden
    
    self.staticPowerBar.image = [UIImage imageNamed: @"breath-bar.png"];
    self.staticPowerBar.alpha = 0.7;
    [self.staticPowerBar sizeToFit];
    self.staticPowerBar.center = CGPointMake(0, self.imageView.image.size.height / 2);
    self.staticPowerBar.hidden = YES; // Keep it hidden
    
    NSArray *windSuckFrames = imageToFrames(@"windsuck.png", 4, 2);
    CGSize frameSize = ((UIImage*) [windSuckFrames objectAtIndex: 0]).size;
    self.windSuckView.frame = CGRectMake(210, -35, frameSize.width, frameSize.height);
    self.windSuckView.animationImages = windSuckFrames;
    self.windSuckView.hidden = NO;
}

- (void) setUpForBuilder {
    [super setUpForBuilder];
    
    self.imageView.animationImages = nil;
    
    self.arrowView.image = nil;
    self.arrowView.hidden = YES;
    
    self.degreeView.image = nil;
    self.degreeView.hidden = YES;
    
    [self.arrowView removeGestureRecognizer: moveArrow];
    moveArrow = nil;
    
    [self.imageView removeGestureRecognizer: blowBreath];
    blowBreath = nil;
    
    self.powerBar.image = nil;
    self.powerBar.hidden = YES;
    
    self.staticPowerBar.image = nil;
    self.staticPowerBar.hidden = YES;
    
    self.windSuckView.image = nil;
    self.windSuckView.animationImages = nil;
    self.windSuckView.hidden = YES;
}

- (void) updateView {
    [super updateView];
    
    self.arrowView.center = [self.view convertPoint: CGPointMake(220, 30) toView: self.view.superview];
    // DLog(@"%f %f", self.arrowView.center.x, self.arrowView.center.y);
    self.arrowView.transform = CGAffineTransformMakeRotation(body->GetAngle() + (M_PI / 2 - self.blowingAngle));
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
    
    CGFloat finalAngle = MIN(MAX(self.blowingAngle - [gesture rotation], MIN_BLOWING_ANGLE), MAX_BLOWING_ANGLE);
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
        self.staticPowerBar.hidden = NO;
        
        __counter = 0;
        powerTimer = [NSTimer scheduledTimerWithTimeInterval: 1 / 60. 
                                                      target: self 
                                                    selector: @selector(variesPower:) 
                                                    userInfo: nil 
                                                     repeats: YES];
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        [powerTimer invalidate];
        powerTimer = nil;
        
        DLog(@"Power: %f", power);
        
        [self.imageView startAnimating];
        [self.windSuckView startAnimating];
        
        b2Vec2 powerVec(self.power * cos(- self.blowingAngle - self.angle) * MAX_BLOWING_POWER, self.power * sin(- self.blowingAngle - self.angle) * MAX_BLOWING_POWER);
        [(GameViewController*) self.parentViewController createBreath: powerVec from: self.arrowView.center];
        
        self.powerBar.hidden = YES;
        self.staticPowerBar.hidden = YES;
    } else if ([gesture state] == UIGestureRecognizerStateCancelled) {
        DLog(@"WARNING: Gesture cancelled on %@", self);
        [powerTimer invalidate];
        powerTimer = nil;
        
        self.powerBar.hidden = YES;
        self.staticPowerBar.hidden = YES;
    }
}

- (void) variesPower: (NSTimer*) timer {
    power = (CGFloat) abs(__counter++ % (NUM_POWER_QUANTUM * 2) - NUM_POWER_QUANTUM) / NUM_POWER_QUANTUM;
    self.powerBar.center = CGPointMake(0, self.imageView.image.size.height / 2 * (2 - power));
    self.powerBar.bounds = CGRectMake(self.powerBar.bounds.origin.x, 
                                      self.powerBar.bounds.origin.y,
                                      self.powerBar.image.size.width,
                                      self.powerBar.image.size.height * power);
}

#pragma mark - View life cycle

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self.view setAutoresizesSubviews: YES];
    [self.view setBackgroundColor: [UIColor clearColor]];

    // Set up the wolf image view
    UIImage *wolfImage = [[GameWolf getWolfImages] objectAtIndex: 0];
    imageView = [[UIImageView alloc] initWithImage: wolfImage];
    
    self.imageView.userInteractionEnabled = YES;
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
    self.arrowView.userInteractionEnabled = YES;
    self.arrowView.contentMode = UIViewContentModeTop;
    
    // Set up image view for power bar
    powerBar = [[UIImageView alloc] init];
    self.powerBar.clipsToBounds = YES;
    self.powerBar.contentMode = UIViewContentModeBottom;
    self.powerBar.hidden = YES;
    
    [self.view addSubview: self.powerBar];
    
    // Set up image view for static power bar
    staticPowerBar = [[UIImageView alloc] init];
    self.staticPowerBar.hidden = YES;
    
    [self.view insertSubview: self.staticPowerBar belowSubview: self.powerBar];
    
    // Set up image view for wind sucking
    windSuckView = [[UIImageView alloc] init];
    self.windSuckView.animationRepeatCount = 1;
    self.windSuckView.animationDuration = BLOWING_TIME;
    self.windSuckView.hidden = YES;
    
    [self.view addSubview: self.windSuckView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    // TODO: Not too sure about how to take care of memory warning.
    // imageView = nil;
    degreeView = nil;
    arrowView = nil;
    powerBar = nil;
    staticPowerBar = nil;
    windSuckView = nil;
}

@end
