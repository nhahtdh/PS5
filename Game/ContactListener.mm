//
//  ContactListener.mm
//  Game
//
//  Created by  on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <Box2D/Box2D.h>
#include "GameObject.h"

class ContactListener: public b2ContactListener {
public:
    void PreSolve(b2Contact* contact, const b2Manifold *oldManifold) {
        id userDataA = (__bridge id) contact->GetFixtureA()->GetBody()->GetUserData();
        id userDataB = (__bridge id) contact->GetFixtureB()->GetBody()->GetUserData();
        
        if (userDataA && userDataB) {
            assert([userDataA isKindOfClass: [GameObject class]]);
            assert([userDataB isKindOfClass: [GameObject class]]);
            
            GameObject *objectA = userDataA;
            GameObject *objectB = userDataB;
            
            if ((objectA.kGameObjectType == kGameObjectWolf && objectB.kGameObjectType == kGameObjectBreath) ||
                (objectB.kGameObjectType == kGameObjectWolf && objectA.kGameObjectType == kGameObjectBreath))
                contact->SetEnabled(false);
        }
    }
    
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {
		id userDataA = (__bridge id) contact->GetFixtureA()->GetBody()->GetUserData();
        if (userDataA && [userDataA isKindOfClass: [GameObject class]]) {
            [userDataA applyDamage: impulse];
        }
        
        id userDataB = (__bridge id) contact->GetFixtureB()->GetBody()->GetUserData();
        if (userDataB && [userDataB isKindOfClass: [GameObject class]]) {
            [userDataB applyDamage: impulse];
        }
	}
};



