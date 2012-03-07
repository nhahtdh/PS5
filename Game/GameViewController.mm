//
//  ViewController.m
//  Game
//
//  Created by  on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "GameBlock.h"
#import "GamePig.h"
#import "GameWolf.h"

@implementation GameViewController

@synthesize kGameMode = kGameMode_;

@synthesize gameObjectsInGameArea = gameObjectsInGameArea_;
@synthesize gameArea;

@synthesize gameObjectsInPalette = gameObjectsInPalette_;
@synthesize palette;

@synthesize playButton;
@synthesize loadButton;
@synthesize saveButton;
@synthesize resetButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)checkRep {
    // REQUIRES: Level builder mode.
    // EFFECTS: This function checks game objects in palette and game area to make
    //          sure there is only 1 wolf, 1 pig in total, and there is always a
    //          block in the palette.
    //          Note that the function only checks the arrays containing the game
    //          objects. It will not check the view of the game objects.
    
    // TODO: Allow more pigs
    int wolfCount = 0, pigCount = 0;
    int blockCount = 0;
    BOOL blockInPalette = NO;
    
    for (GameObject* o in self.gameObjectsInPalette) {
        switch ([o kGameObjectType]) {
            case kGameObjectWolf:
                wolfCount++;
                break;
            case kGameObjectPig:
                pigCount++;
                break;
            case kGameObjectBlock:
                blockInPalette = YES;
                blockCount++;
                break;
            default:
                @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                               reason: @"Unrecognized object type" userInfo: nil];
        } 
    }
    
    DLog(@"Palette: %dW %dP %dB %@", wolfCount, pigCount, blockCount, blockInPalette ? @"YES" : @"NO");
    
    assert(blockCount == 1);
    
    for (GameObject* o in self.gameObjectsInGameArea) {
        switch ([o kGameObjectType]) {
            case kGameObjectWolf:
                wolfCount++;
                break;
            case kGameObjectPig:
                pigCount++;
                break;
            case kGameObjectBlock:
                blockCount++;
                break;
            default:
                @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                               reason: @"Unrecognized object type" userInfo: nil];
        }
    }

    DLog(@"Both: %dW %dP %dB %@", wolfCount, pigCount, blockCount, blockInPalette ? @"YES" : @"NO");
    
    assert(wolfCount == 1);
    assert(pigCount == 1);
    assert(blockInPalette);
}

- (void) addGameObjectToPalette:(GameObject *)gameObject {
    [self.gameObjectsInPalette addObject: gameObject];
    
    [self addChildViewController: gameObject];
}

- (void)removeGameObjectFromPalette: (GameObject*) gameObject {
    [self.gameObjectsInPalette removeObject: gameObject];
}

- (void)redrawPalette {
    for (UIView *subview in palette.subviews) {
        [subview removeFromSuperview];
    }
    
    CGFloat padding = 20.;
    CGPoint center = CGPointMake(padding, palette.bounds.size.height / 2);
    
    for (GameObject* object in self.gameObjectsInPalette) {
        assert(object.kGameObjectState != kGameObjectStateOnGameArea);
        
        if (object.kGameObjectState == kGameObjectStateOnPalette) {
            [palette addSubview: object.view];
            
            [object resetToPaletteIcon];
            [object.view setCenter: CGPointMake(center.x + object.defaultIconSize.width / 2, center.y)];
            
            center = CGPointMake(center.x + object.defaultIconSize.width + padding, center.y);
        }
    }
    
    // This is obviously not a very good way to check, but this is the only place
    // that we can be sure that all operations on gameObjectsInPalette and
    // gameObjectInGameArea have finished.
    [self checkRep];
}

- (void)setUpPalette {
    [self addGameObjectToPalette: [GameObject GameObjectCreate: kGameObjectWolf]];
    [self addGameObjectToPalette: [GameObject GameObjectCreate: kGameObjectPig]];
    [self addGameObjectToPalette: [GameObject GameObjectCreate: kGameObjectBlock]];
    
    [self redrawPalette];
}

- (void) setUpGameArea {
    // Load the images into UIImage objects
    UIImage *bgImage = [UIImage imageNamed:@"background.png"];
    UIImage *groundImage = [UIImage imageNamed:@"ground.png"];
    
    // Get the width and height of the two images
    CGFloat backgroundWidth = bgImage.size.width;
    CGFloat backgroundHeight = bgImage.size.height;
    CGFloat groundWidth = groundImage.size.width;
    CGFloat groundHeight = groundImage.size.height;
    
    // Place each of them in an UIImageView
    UIImageView *background = [[UIImageView alloc] initWithImage:bgImage];
    UIImageView *ground = [[UIImageView alloc] initWithImage:groundImage];
    CGFloat groundY = gameArea.frame.size.height - groundHeight;
    CGFloat backgroundY = groundY - backgroundHeight;
    
    background.frame = CGRectMake(0, backgroundY, backgroundWidth, backgroundHeight);
    ground.frame = CGRectMake(0, groundY, groundWidth, groundHeight);
    
    // Add these views as subviews of the gameArea.
    [gameArea addSubview:background];
    [gameArea addSubview:ground];
    
    // Set the content size so that gameArea is scrollable
    // otherwise it defaults to the current window size
    CGFloat gameAreaHeight = backgroundHeight + groundHeight;
    CGFloat gameAreaWidth = backgroundWidth;
    [gameArea setContentSize:CGSizeMake(gameAreaWidth, gameAreaHeight)];
    
    // Setup physics representation of the ground
    b2BodyDef groundBodyDef;
    groundBodyDef.type = b2_staticBody;
    groundBodyDef.angle = 0.;
    // Sink the ground by a small amount so that we can increase the height of the ground.
    // The actual amount increased will be heightDelta * 2
    // The width will also be increased to prevent odd effects at the edge of the screen.
    double widthDelta = 3.;
    double heightDelta = 3.;
    groundBodyDef.position.Set(pixelToMeter(ground.center.x), pixelToMeter(ground.center.y) + heightDelta);
    
    b2Body* groundBody = gameWorld->CreateBody(&groundBodyDef);
    b2PolygonShape groundShape;
    groundShape.SetAsBox(pixelToMeter(ground.frame.size.width) / 2. + widthDelta, 
                         pixelToMeter(ground.frame.size.height) / 2. + heightDelta);
    
    b2FixtureDef groundFixtureDef;
    groundFixtureDef.restitution = 0.1;
    groundFixtureDef.friction = 0.75;
    groundFixtureDef.density = 1.;
    groundFixtureDef.shape = &groundShape;
    groundBody->CreateFixture(&groundFixtureDef);
}

- (void) setUpButtons {
    UIColor *disabledTitleColor = [UIColor grayColor];
    [loadButton setTitleColor: disabledTitleColor forState: UIControlStateDisabled];
    [saveButton setTitleColor: disabledTitleColor forState: UIControlStateDisabled];
    [resetButton setTitleColor: disabledTitleColor forState: UIControlStateDisabled];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    DLog(@"viewDidLoad called");
    [super viewDidLoad];
    
    // Initiate the game world
    b2Vec2 gravity(0, 10.);
    gameWorld = new b2World(gravity);
    
    gameObjectsInGameArea_ = [NSMutableArray array];
    gameObjectsInPalette_ = [NSMutableArray array];
    
    // Set up game area
    [self setUpGameArea];
    
    // Set up palette
    [self setUpPalette];
    
    // Set up button
    [self setUpButtons];
}

- (void)viewDidUnload
{
    DLog(@"viewDidUnload called");
    [self setGameArea:nil];
    [self setPalette:nil];
    
    [self setLoadButton:nil];
    [self setSaveButton:nil];
    [self setResetButton:nil];
    [self setPlayButton:nil];
    
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    return NO;
}

#pragma mark - Game mechanics

- (BOOL) canPlay {
    int numWolf = 0;
    int numPig = 0;
    
    for (GameObject *o in self.gameObjectsInGameArea) {
        if (o.kGameObjectType == kGameObjectWolf) {
            numWolf++;
        } else if (o.kGameObjectType == kGameObjectPig) {
            numPig++;
        }
    }
    
    DLog(@"Wolf:%d Pig:%d", numWolf, numPig);
    
    // TODO: Reenable this
    // return numWolf == 1 && numPig >= 1;
    return YES;
}

- (void) setUpPhysicsBody: (GameObject*) o {
    assert(o.body == nil);
    assert(o.kGameObjectState == kGameObjectStateOnGameArea);
    
    const b2BodyDef& bodyDef = o.bodyDef;
    b2Shape *shape = o.shape;
    const b2FixtureDef& noShapeFixtureDef = o.fixtureDef;
    
    b2FixtureDef fixtureDef(noShapeFixtureDef);
    fixtureDef.shape = shape;
    
    o.body = gameWorld->CreateBody(&bodyDef);
    o.body->CreateFixture(&fixtureDef);
    o.body->SetUserData((__bridge void *) o);
    
    delete shape;
    
    DLog(@"Mass of %@: %f", o, o.body->GetMass());
}

- (void) setUpBeforePlay {
    for (GameObject* o in self.gameObjectsInGameArea) {
        assert(o.kGameObjectType != kGameObjectBreath);
        [self setUpPhysicsBody: o];
        [o setUpForPlay];
    }
    
    contactListener = new ContactListener();
    gameWorld->SetContactListener(contactListener);
}

- (void) tearDownAfterPlay {
    gameWorld->SetContactListener(NULL);
    contactListener->~ContactListener();
    
    NSMutableArray *leftoverGameBreath = [NSMutableArray array];
    
    for (GameObject *o in self.gameObjectsInGameArea) {
        // An object may be removed from the game world during game play
        // We only remove objects that are not yet destroyed.
        if (o.body != nil) {
            gameWorld->DestroyBody(o.body);
            o.body = nil;
        }
        
        o.view.hidden = NO;
        
        if (o.kGameObjectType == kGameObjectBreath) {
            [leftoverGameBreath addObject: o];
        } else {
            [o setUpForBuilder];
        }
    }
    
    // Remove all leftover GameBreath, if any
    for (GameObject *o in leftoverGameBreath) {
        [o.view removeFromSuperview];
        
        [self.gameObjectsInGameArea removeObject: o];
    }
    
    [leftoverGameBreath removeAllObjects];
}

- (void) updateView: (NSTimer*) timer {
    gameWorld->Step(DEFAULT_TIME_STEP, DEFAULT_VELOCITY_ITERATIONS, DEFAULT_POSITION_ITERATIONS);
    
    for (GameObject *o in self.gameObjectsInGameArea) {
        if (o.body) {
            // If the object was not destroyed
            [o updateView];
            // TODO: Change this later
            if (o.damage > 100) {
                // Remove the object from the game world
                gameWorld->DestroyBody(o.body);
                o.body = nil;
                
                // Hide the view
                o.view.hidden = YES;
            }
        }
    }
}

- (void) createBreath:(b2Vec2)power from:(CGPoint)position {
    assert(self.kGameMode == kGameModePlay);
    
    GameBreath *breath = [[GameBreath alloc] init];
    [self.gameObjectsInGameArea addObject: breath];
    
    [self.gameArea addSubview: breath.view];
    breath.view.center = position;
    
    [self setUpPhysicsBody: breath];
    [breath setUpForPlay];
    
    [breath launch: power];
    
    if (!contactListener->GetShouldApplyDamage()) {
        contactListener->SetShouldApplyDamage(true);
    }
}

/*
 - (void) destroyBreath: (GameBreath*) gameBreath {
 
 }
 */

- (void) playMode {
    assert(updateTimer == nil);
    
    // Set game mode
    kGameMode_ = kGameModePlay;
    
    // Disable buttons
    self.loadButton.hidden = YES;
    self.saveButton.hidden = YES;
    self.resetButton.hidden = YES;
    
    [self.playButton setTitle: @"End" forState: UIControlStateNormal];
    [self.playButton setTitle: @"End" forState: UIControlStateHighlighted];
    
    // TODO: What the palette should show when the user is playing.
    // Make sure the states are consistent throughout
    self.palette.userInteractionEnabled = NO;
    
    [self setUpBeforePlay];
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval: 1. / UPDATES_PER_SECOND
                                                   target: self 
                                                 selector: @selector(updateView:)
                                                 userInfo: nil 
                                                  repeats: YES];
}

// TODO: Make sure this function is safe to call when the wolf die
- (void) builderMode {
    // Remove the timer
    [updateTimer invalidate];
    updateTimer = nil;
    
    // Tearing down physical object should only be done after the timer is invalidated
    // to prevent accessing inexistent objects
    [self tearDownAfterPlay];
    
    // Set game mode
    kGameMode_ = kGameModeBuilder;
    
    // Enable buttons
    self.loadButton.hidden = NO;
    self.saveButton.hidden = NO;
    self.resetButton.hidden = NO;
    
    [self.playButton setTitle: @"Play" forState: UIControlStateNormal];
    [self.playButton setTitle: @"Play" forState: UIControlStateHighlighted];
    
    // TODO: Palette.
    self.palette.userInteractionEnabled = YES;
}


#pragma mark - Handle button events

- (IBAction)buttonPressed:(id)sender {
    /*
    UIColor *newColor;
    UIButton *button = (UIButton*)sender;
    if ([button titleColorForState:UIControlStateNormal] ==
        [UIColor blackColor]) {
        newColor = [UIColor lightGrayColor];
    } else {
        newColor = [UIColor blackColor];
    }
    [button setTitleColor:newColor forState:UIControlStateNormal];
     */
}

- (IBAction)resetButtonPressed:(id)sender {
    DLog(@"Level builder is reset");    
    
    for (GameObject* o in self.gameObjectsInPalette) {
        [o.view removeFromSuperview];
        [o removeFromParentViewController];
    }
    [self.gameObjectsInPalette removeAllObjects];
    
    for (GameObject* o in self.gameObjectsInGameArea) {
        [o.view removeFromSuperview];
        [o removeFromParentViewController];
    }
    [self.gameObjectsInGameArea removeAllObjects];
    
    [self setUpPalette];
}

- (IBAction)playButtonPressed:(id)sender {
    DLog(@"%@ button pressed", self.playButton.titleLabel.text);
    if (self.kGameMode == kGameModeBuilder) {
        if (![self canPlay]) {
            DLog(@"Failed to start");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Failed to start"
                                                            message: @"There must be at least one wolf and one pig in the game area."
                                                           delegate: nil
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        [self playMode];
    } else if (self.kGameMode == kGameModePlay) {
        [self builderMode];
    } else {
        @throw [NSException exceptionWithName: @"Not implemented exception" 
                                       reason: @"Unimplemented game mode" 
                                     userInfo: nil];
    }
}

@end
