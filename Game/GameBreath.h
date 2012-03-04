//
//  GameBreath.h
//  Game
//
//  Created by  on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Box2D/Box2D.h>
#import "ContactListenerProtocol.h"

@interface GameBreath : UIViewController<ContactListenerProtocol> {
    UIImageView *imageView;
    
    b2Vec2 power;
    b2Vec2 position;
    
    b2Body* body;
}

- (id) initWithPower: (b2Vec2) power from: (b2Vec2) position;

@property (strong, nonatomic, readonly) UIImageView *imageView;

#pragma mark - Game properties

@property (nonatomic, readonly) b2BodyDef bodyDef;
@property (nonatomic, readonly) b2Shape *shape;
// NOTE: Every time the shape is retrieved, the caller is responsible for destroying the object
@property (nonatomic, readonly) b2FixtureDef fixtureDef;

@property b2Body *body;

- (void) applyDamage:(const b2ContactImpulse *)impulses;

@end
