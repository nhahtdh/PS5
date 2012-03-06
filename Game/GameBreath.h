//
//  GameBreath.h
//  Game
//
//  Created by  on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"

@interface GameBreath : GameObject {
    b2Vec2 power;
    b2Vec2 position;
}

- (id) initWithPower: (b2Vec2) power from: (b2Vec2) position;

#pragma mark - Game properties

@property (nonatomic, readonly) b2BodyDef bodyDef;
@property (nonatomic, readonly) b2Shape *shape;
// NOTE: Every time the shape is retrieved, the caller is responsible for destroying the object
@property (nonatomic, readonly) b2FixtureDef fixtureDef;

- (void) applyDamage:(const b2ContactImpulse *)impulses;

@end
