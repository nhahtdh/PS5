//
//  GameBreath.m
//  Game
//
//  Created by  on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameBreath.h"

@implementation GameBreath

@synthesize kGameObjectState = kGameObjectState_;

- (id) init {
    if (self = [super init]) {
        kGameObjectState_ = kGameObjectStateOnGameArea;
    }
    
    return self;
}

+ (NSArray*) windBlowImages {
    static NSArray* frames;
    if (frames == nil) {
        frames = imageToFrames(@"windblow.png", 4, 1);
    }
    return frames;
}

/*

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
 */

- (CGSize) defaultImageSize {
    static const CGSize size = CGSizeMake(110, 104);
    return size;
}

- (CGSize) defaultIconSize {
    // NOTE: This function is not defined for GameBreath
    assert(0);
}

- (b2BodyDef) bodyDef {
    b2BodyDef bodyDef;
    bodyDef.position.Set(pixelToMeter(self.view.center.x), pixelToMeter(self.view.center.y));
    bodyDef.type = b2_dynamicBody;
    bodyDef.angle = self.angle;
    return bodyDef;
}

- (b2Shape*) shape {
    b2CircleShape *shape = new b2CircleShape();
    // Note: The value is slightly less than the defaultImageSize to account for blank spaces
    shape->m_radius = pixelToMeter(self.defaultImageSize.height * 0.9);
    
    return shape;
}

- (b2FixtureDef) fixtureDef {
    b2FixtureDef fixtureDef;
    
    fixtureDef.density = 5;
    fixtureDef.friction = 0.2;
    fixtureDef.restitution = 0.1;
    
    return fixtureDef;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView.image = [[GameBreath windBlowImages] objectAtIndex: 0];
    [self.imageView sizeToFit];
    self.imageView.animationImages = [GameBreath windBlowImages];
    self.imageView.animationRepeatCount = 0; // No limit
    self.imageView.animationDuration = 0.5;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
