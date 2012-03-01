//
//  GameBlock.h
//  Game
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"


typedef enum {kGameBlockStraw, kGameBlockWood, kGameBlockIron, kGameBlockStone} GameBlockType;

@interface GameBlock : GameObject {
    GameBlockType kGameBlockType;
    
    UITapGestureRecognizer *tap;
}

@property (nonatomic, readwrite) GameBlockType kGameBlockType;

- (void) changeBlockType: (UIGestureRecognizer*) gesture;
// MODIFIES: object model (block type)
// REQUIRES: game in designer mode
// EFFECTS: the object changes block type

#pragma mark Gameplay mechanics

- (void) setUpForPlay;

- (void) setUpForBuilder;

@end
