//
//  GameBreath.m
//  Game
//
//  Created by  on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameBreath.h"

@implementation GameBreath

@synthesize kGameObjectState = kGameObjectState_;

- (id) init {
    if (self = [super init]) {
        kGameObjectState_ = kGameObjectStateOnGameArea;
    }
    
    return self;
}

+ (NSArray*) windBlow {
    static NSArray* frames;
    if (frames == nil) {
        frames = imageToFrames(@"windblow.png", 4, 1);
    }
    return frames;
}

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
 */

- (CGSize) defaultIconSize {
    // NOTE: This function is not defined for GameBreath
    assert(0);
}

- (b2BodyDef) bodyDef {
    b2BodyDef bodyDef;
    bodyDef.position.Set(pixelToMeter(self.view.center.x), pixelToMeter(self.view.center.y));
    bodyDef.type = b2_dynamicBody;
    bodyDef.angle = self.angle;
    return bodyDef;
}

- (b2Shape*) shape {
    b2CircleShape *shape = new b2CircleShape();
    // TODO: Fill in the value
    // shape->m_radius = ;
    
    return shape;
}

- (b2FixtureDef) fixtureDef {
    b2FixtureDef fixtureDef;
    
    fixtureDef.density = 5;
    fixtureDef.friction = 0.2;
    fixtureDef.restitution = 0.1;
    
    return fixtureDef;
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
