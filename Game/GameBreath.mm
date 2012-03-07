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

@synthesize kGameObjectState = kGameObjectState_;

+ (NSArray*) windBlowImages {
    static NSArray* frames;
    if (frames == nil) {
        frames = imageToFrames(@"windblow.png", 4, 1);
    }
    return frames;
}

- (id) init {
    if (self = [super init]) {
        kGameObjectState_ = kGameObjectStateOnGameArea;
    }
    
    return self;
}

#pragma mark - GameBreath view

- (CGSize) defaultImageSize {
    return [(UIImage*) [[GameBreath windBlowImages] objectAtIndex:0] size];
}

#pragma mark - Game properties

- (GameObjectType) kGameObjectType {
    return kGameObjectBreath;
}

- (b2BodyDef) bodyDef {
    // REQUIRES: This function should only be called after it is confirmed that the game should start.
    // The object should also be properly inside the game area.
    
    b2BodyDef bodyDef;
    bodyDef.position = b2Vec2(pixelToMeter(self.view.center.x), pixelToMeter(self.view.center.y));
    DLog(@"%f %f", self.view.center.x, self.view.center.y);
    bodyDef.type = b2_dynamicBody;
    return bodyDef;
}

- (b2Shape*) shape {
    b2CircleShape *shape = new b2CircleShape();
    // Since the dimensions are not equal, take the average. Since this is the radius, divide by 2 once more
    shape->m_radius = pixelToMeter((self.defaultImageSize.height + self.defaultImageSize.width) / 4);
    DLog(@"%f", shape->m_radius);
    
    return shape;
}

- (b2FixtureDef) fixtureDef {
    b2FixtureDef fixtureDef;
    
    fixtureDef.density = 3;
    fixtureDef.friction = 0.8;
    fixtureDef.restitution = 0.1;
    
    return fixtureDef;
}

#pragma mark - Game mechanics

- (void) launch:(b2Vec2)power {
    // self.body->ApplyForceToCenter(power);
    
    self.body->ApplyLinearImpulse(power, self.body->GetPosition());
    [NSTimer scheduledTimerWithTimeInterval: 1 
                                     target: self.imageView 
                                   selector: @selector(startAnimating) 
                                   userInfo: nil
                                    repeats: NO];
}

- (void) setUpForPlay {
    // NOTE: Currently, this function will call the method defined in the superclass
    //       since there are no extra effect.
    //       This function should be modified if there are extra effects that affect
    //       the consistency of the program.
    
    [super setUpForPlay];
}

- (void) applyDamage:(const b2ContactImpulse *)impulses {
    [super applyDamage: impulses];
}

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

    imageView = [[UIImageView alloc] init];
    self.imageView.image = [[GameBreath windBlowImages] objectAtIndex: 0];
    [self.imageView sizeToFit];
    self.imageView.animationImages = [GameBreath windBlowImages];
    self.imageView.animationRepeatCount = 0; // No limit
    self.imageView.animationDuration = 0.5;
    
    [self.view addSubview: self.imageView];
    self.view.frame = CGRectMake(0, 0, self.defaultImageSize.width, self.defaultImageSize.height);
    [self.view setBackgroundColor: [UIColor clearColor]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Unimplemented

- (CGSize) defaultIconSize {
    NOT_IMPLEMENTED();
}

- (CGFloat) maxScale {
    NOT_IMPLEMENTED();
}

- (CGFloat) minScale {
    NOT_IMPLEMENTED();
}

- (void) resetToPaletteIcon {
    NOT_IMPLEMENTED();
}

- (void) setUpForBuilder {
    NOT_IMPLEMENTED();
}

@end
