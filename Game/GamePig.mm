//
//  GamePig.m
//  Game
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GamePig.h"

@implementation GamePig

-(GameObjectType) kGameObjectType {
    return kGameObjectPig;
}

- (CGSize) defaultImageSize {
    static const CGSize size = CGSizeMake(88, 88);
    return size;
}

- (CGSize) defaultIconSize {
    static const CGSize size = CGSizeMake(100, 100);
    return size;
}

+ (UIImage*) getImage {
    static UIImage* pigNormal;
    if (pigNormal == nil) {
        pigNormal = [UIImage imageNamed: @"pig.png"];
    }
    return pigNormal;
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
    
    fixtureDef.density = 2.5;
    fixtureDef.friction = 0.2;
    fixtureDef.restitution = 0.1;
    
    return fixtureDef;
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

- (void) viewDidLoad {
    [super viewDidLoad];
    DLog(@"Pig viewDidLoad called.");
    
    [self.view setAutoresizesSubviews: YES];
    
    // UIImage *pigImage = [UIImage imageNamed:@"pig.png"];
    UIImage *pigImage = [GamePig getImage];
    // UIImageView *pigImageView = [[UIImageView alloc] initWithImage: pigImage];
    imageView = [[UIImageView alloc] initWithImage: pigImage];
    
    // [self.view addSubview: pigImageView];
    [self.view addSubview: imageView];
    [self.view setFrame: CGRectMake(0, 0, pigImage.size.width, pigImage.size.height)];
    [self.view setBackgroundColor: [UIColor clearColor]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
