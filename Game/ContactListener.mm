//
//  ContactListener.mm
//  Game
//
//  Created by  on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <Box2D/Box2D.h>

class ContactListener: public b2ContactListener {
public:
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
	{
		
	}
};



