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
    return CGSizeMake(88, 88);
}

- (CGSize) defaultIconSize {
    return CGSizeMake(100, 100);
}

+ (UIImage*) getImage {
    static UIImage* pigNormal;
    if (pigNormal == nil) {
        pigNormal = [UIImage imageNamed: @"pig.png"];
    }
    return pigNormal;
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
    
    fixtureDef.density = 2.5;
    fixtureDef.friction = 0.8;
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
    return YES;
}

-(CGFloat) maxScale {
    return 1.5;
}

-(CGFloat) minScale {
    return 0.8;
}

#pragma mark - View life cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // Set up view
    [self.view setAutoresizesSubviews: YES];
    
    UIImage *pigImage = [GamePig getImage];
    imageView = [[UIImageView alloc] initWithImage: pigImage];
    
    [self.view addSubview: imageView];
    [self.view setBackgroundColor: [UIColor clearColor]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
