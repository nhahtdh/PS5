//
//  GameBreath.h
//  Game
//
//  Created by  on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"

#define NOT_IMPLEMENTED() assert(0)

@interface GameBreath : GameObject

#pragma mark - Game properties

@property (nonatomic, readonly) b2BodyDef bodyDef;
@property (nonatomic, readonly) b2Shape *shape;
// NOTE: Every time the shape is retrieved, the caller is responsible for destroying the object
@property (nonatomic, readonly) b2FixtureDef fixtureDef;

#pragma mark - Game mechanics

- (BOOL) hasExpired;

- (void) launch: (b2Vec2)power;

- (void) setUpForPlay;

@end
