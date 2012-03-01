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
    
    /*
    self.imageView.animationImages = [GameWolf getWolfImages];
    self.imageView.animationDuration = 1;
    [self.imageView startAnimating];
     */
}

- (void) setUpForBuilder {
    [super setUpForBuilder];
    
    // [self.imageView stopAnimating];
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

-(void) changeBlowingAngle: (UIPanGestureRecognizer*) gesture {
    
}

-(void) blowAir: (UITapGestureRecognizer *)gesture {
    
}

#pragma mark - View life cycle

-(void) viewDidLoad {
    [super viewDidLoad];
    
    DLog(@"Wolf viewDidLoad called.");
    
    [self.view setAutoresizesSubviews: YES];
    [self.view setBackgroundColor: [UIColor clearColor]];

    // Set up the wolf image view
    UIImage *wolfImage = [[GameWolf getWolfImages] objectAtIndex: 0];
    imageView = [[UIImageView alloc] initWithImage: wolfImage];
    
    imageView.animationImages = [GameWolf getWolfImages];
    imageView.animationRepeatCount = 1;
    imageView.animationDuration = 1;
    
    [self.view addSubview: imageView];
    
    // Set up the direction degree
    UIImage *degree = [UIImage imageNamed: @"direction-degree.png"];
    degreeView = [[UIImageView alloc] initWithImage: degree];
    [degreeView setFrame: CGRectMake(wolfImage.size.width / 2, 0, degree.size.width, degree.size.height)];
    [degreeView setHidden: YES];
    
    [self.view addSubview: degreeView];
    
    // Set up arrow
    UIImage *arrow = [UIImage imageNamed: @"direction-arrow.png"];
    arrowView = [[UIImageView alloc] initWithImage: arrow];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    imageView = nil;
    degreeView = nil;
    arrowView = nil;
    windSuckView = nil;
}

@end
