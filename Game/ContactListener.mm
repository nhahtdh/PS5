//
//  ContactListener.mm
//  Game
//
//  Created by  on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <Box2D/Box2D.h>
#include "ContactListenerProtocol.h"

class ContactListener: public b2ContactListener {
public:
    void PreSolve(b2Contact* contact, const b2Manifold *oldManifold) {
        
    }
    
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {
		id userDataA = (__bridge id) contact->GetFixtureA()->GetBody()->GetUserData();
        if (userDataA && [userDataA conformsToProtocol: @protocol(ContactListenerProtocol)]) {
            [userDataA applyDamage: impulse];
        }
        
        id userDataB = (__bridge id) contact->GetFixtureB()->GetBody()->GetUserData();
        if (userDataB && [userDataB conformsToProtocol: @protocol(ContactListenerProtocol)]) {
            [userDataB applyDamage: impulse];
        }
	}
};



