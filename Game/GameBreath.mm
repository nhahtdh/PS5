//
//  GameBreath.m
//  Game
//
//  Created by  on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameBreath.h"
#import "Utilities.h"

@implementation GameBreath

@synthesize imageView;
@synthesize body;

+ (NSArray*) windBlowImages {
    static NSArray* frames;
    if (frames == nil) {
        frames = imageToFrames(@"windblow.png", 4, 1);
    }
    return frames;
}

- (CGSize) defaultImageSize {
    static const CGSize size = CGSizeMake(110, 104);
    return size;
}

- (id) initWithPower: (b2Vec2)pow from: (b2Vec2)pos {
    if (self = [super init]) {
        power = pow;
        position = pos;
    }
    
    return self;
}

#pragma mark - Game properties

- (b2BodyDef) bodyDef {
    // REQUIRES: This function should only be called after it is confirmed that the game should start.
    // The object should also be properly inside the game area.
    
    b2BodyDef bodyDef;
    bodyDef.position = position;
    bodyDef.type = b2_dynamicBody;
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

#pragma mark - Game mechanics

- (void) applyDamage:(const b2ContactImpulse *)impulses {}

/*
- (void) setUpForPlay {
    [super setUpForPlay];
    
    
    
    // body->ApplyForce(<#const b2Vec2 &force#>, <#const b2Vec2 &point#>)
}
 */

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageView.image = [[GameBreath windBlowImages] objectAtIndex: 0];
    [self.imageView sizeToFit];
    self.imageView.animationImages = [GameBreath windBlowImages];
    self.imageView.animationRepeatCount = 0; // No limit
    self.imageView.animationDuration = 0.5;
    self.imageView.center = CGPointMake(meterToPixel(position.x), meterToPixel(position.y));
    
    [self.view addSubview: self.imageView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
