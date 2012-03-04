//
//  ContactListenerProtocol.h
//  Game
//
//  Created by  on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Box2D/Box2D.h>

@protocol ContactListenerProtocol <NSObject>

- (void) applyDamage:(const b2ContactImpulse *)impulses;

@end
