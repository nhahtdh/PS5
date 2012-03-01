//
//  GameWolf.m
//  Game
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameWolf.h"

@implementation GameWolf

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
        // TODO: defaultImageSize
        wolfAliveFrames = imageToFrames(@"wolfs.png", CGSizeMake(225, 150));
    }
    
    return wolfAliveFrames;
}

// TODO: Check whether this function return properly or not
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

// TODO: Check whether this function return properly or not
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

#pragma mark - View life cycle

-(void) viewDidLoad {
    [super viewDidLoad];
    
    DLog(@"Wolf viewDidLoad called.");
    
    [self.view setAutoresizesSubviews: YES];

    // Get the first frame of the wolf image
    UIImage *wolfImage = [[GameWolf getWolfImages] objectAtIndex: 0];
    
    // Configure the image view that contain the wolf image
    imageView = [[UIImageView alloc] initWithImage: wolfImage];
    
    [self.view addSubview: imageView];
    [self.view setFrame: CGRectMake(0, 0, wolfImage.size.width, wolfImage.size.height)];
    [self.view setBackgroundColor: [UIColor clearColor]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
