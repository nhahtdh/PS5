//
//  GameBlock.h
//  Game
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"


typedef enum {kGameBlockStraw, kGameBlockWood, kGameBlockIron, kGameBlockStone} GameBlockType;

#define NUM_BLOCK_TYPE 4

@interface GameBlock : GameObject {
    GameBlockType kGameBlockType;
    
    UITapGestureRecognizer *tap;
}

@property (nonatomic, readwrite) GameBlockType kGameBlockType;

#pragma mark Game mechanics

- (void) setUpForPlay;

- (void) setUpForBuilder;

- (void) applyDamage:(const b2ContactImpulse *)impulses;

@end
