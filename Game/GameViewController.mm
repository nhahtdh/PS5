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
    [gameObject resetToPaletteIcon];
    
    [self.gameObjectsInPalette addObject: gameObject];
    
    [self addChildViewController: gameObject];
    
}

- (void)removeGameObjectFromPalette: (GameObject*) gameObject {
    [self.gameObjectsInPalette removeObject: gameObject];
}

- (void)addGameObjectToGameArea:(GameObject *)gameObject {
    [self.gameObjectsInGameArea addObject: gameObject];
}

- (void)removeGameObjectFromGameArea:(GameObject *)gameObject {
    [self.gameObjectsInGameArea removeObject: gameObject];
}

- (void)redrawPalette {
    for (UIView *subview in palette.subviews) {
        [subview removeFromSuperview];
    }
    
    CGFloat padding = 20.;
    CGPoint center = CGPointMake(padding, palette.bounds.size.height / 2);
    
    for (GameObject* object in self.gameObjectsInPalette) {
        if (object.kGameObjectState == kGameObjectStateOnPalette) {
            [object.view setCenter: CGPointMake(center.x + object.defaultIconSize.width / 2, center.y)];
            [palette addSubview: object.view];
            
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
    
    // The frame property holds the position and size of the views
    // The CGRectMake methods arguments are : x position, y position, width,
    // height
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
    
    // TODO: This function does more than its description
    
    // Setup physics representation of the ground
    b2BodyDef groundBodyDef;
    groundBodyDef.type = b2_staticBody;
    groundBodyDef.angle = 0.;
    // Sink the ground by a small amount so that we can increase the height of the ground.
    // The actual amount increased will be heightDelta * 2
    // The width will also be increased to prevent odd effects at the edge of the screen.
    double widthDelta = 3.;
    double heightDelta = 3.;
    groundBodyDef.position.Set(pixelToMeter(ground.center.x), pixelToMeter(ground.center.y) - heightDelta);
    
    b2Body* groundBody = gameWorld->CreateBody(&groundBodyDef);
    b2PolygonShape groundShape;
    groundShape.SetAsBox(pixelToMeter(ground.frame.size.width) + widthDelta, 
                         pixelToMeter(ground.frame.size.height) + heightDelta);
    
    b2FixtureDef groundFixtureDef;
    groundFixtureDef.restitution = 0.1;
    groundFixtureDef.friction = 0.3;
    groundFixtureDef.density = 1.;
    groundFixtureDef.shape = &groundShape;
    groundBody->CreateFixture(&groundFixtureDef);
}

- (void) setUpButtons {
    // [playButton setTitleColor: [UIColor grayColor] forState: UIControlStateDisabled];
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

#pragma mark Handle button events

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
    
    // gameObjectsInGameArea_ = [NSMutableArray array];
    // gameObjectsInPalette_ = [NSMutableArray array];

    // [self setUpGameArea];
    [self setUpPalette];
}

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
    
    return numWolf == 1 && numPig >= 1;
}

- (IBAction)playButtonPressed:(id)sender {
    DLog(@"Play button pressed");
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
        
        kGameMode_ = kGameModePlay;
        
        // Disable buttons
        loadButton.enabled = NO;
        saveButton.enabled = NO;
        resetButton.enabled = NO;
        
        // TODO: Disable the palette
        
    } else if (self.kGameMode == kGameModePlay) {
        kGameMode_ = kGameModeBuilder;
        
        // Enable buttons
        loadButton.enabled = YES;
        saveButton.enabled = YES;
        resetButton.enabled = YES;
    } else {
        @throw [NSException exceptionWithName:@"Not implemented exception" reason: @"Unimplemented game mode" userInfo: nil];
    }
}

@end
