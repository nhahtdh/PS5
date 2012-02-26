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

// @synthesize inPlayGameObjects;
@synthesize gameObjectsInGameArea = gameObjectsInGameArea_;
@synthesize gameArea;

@synthesize gameObjectsInPalette = gameObjectsInPalette_;
// @synthesize paletteGameObjects;
@synthesize palette;

/*
- (id) init {
    DLog(@"init called.");
    if (self = [super init]) {
        gameObjects = [NSMutableArray array];
    }
    return self;
}
 
- (id) initWithCoder:(NSCoder *)aDecoder {
    DLog(@"initWithCoder called.");
    if (self = [super initWithCoder:aDecoder]) {
        gameObjects = [NSMutableArray array];
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    DLog(@"initWithNibName called.");
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        gameObjects = [NSMutableArray array];
    }
    return self;
}
 
 */

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
    int wolfCount = 0, pigCount = 0;
    int blockCount = 0;
    BOOL blockInPalette = NO;
    
    // @synchronized (gameObjectsInPalette) {
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
    // }
    
    DLog(@"Palette: %dW %dP %dB %@", wolfCount, pigCount, blockCount, blockInPalette ? @"YES" : @"NO");
    
    assert(blockCount == 1);
    
    // @synchronized (gameObjectsInGameArea) {
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
    // }
    
    DLog(@"Both: %dW %dP %dB %@", wolfCount, pigCount, blockCount, blockInPalette ? @"YES" : @"NO");
    
    assert(wolfCount == 1);
    assert(pigCount == 1);
    assert(blockInPalette);
}

- (void) addGameObjectToPalette:(GameObject *)gameObject {
    [gameObject resetToPaletteIcon];
    
    // @synchronized (gameObjectsInPalette) {
    //     [gameObjectsInPalette addObject: gameObject];
    // }
    
    [self.gameObjectsInPalette addObject: gameObject];
    
    [self addChildViewController: gameObject];
    
}

- (void)removeGameObjectFromPalette: (GameObject*) gameObject {
    // @synchronized (gameObjectsInPalette) {
    //     [gameObjectsInPalette removeObject: gameObject];
    // }
    [self.gameObjectsInPalette removeObject: gameObject];
}

- (void)addGameObjectToGameArea:(GameObject *)gameObject {
    // @synchronized (gameObjectsInGameArea) {
    //    [gameObjectsInGameArea addObject: gameObject];
    // }
    [self.gameObjectsInGameArea addObject: gameObject];
}

- (void)removeGameObjectFromGameArea:(GameObject *)gameObject {
    // @synchronized (gameObjectsInGameArea) {
    //    [gameObjectsInGameArea removeObject: gameObject];
    // }
    [self.gameObjectsInGameArea removeObject: gameObject];
}

/*
 - (void)moveGameObjectToGameArea: (GameObject*) gameObject {
    [inPlayGameObjects addObject: gameObject];
    [paletteGameObjects removeObject: gameObject];
    
    [gameArea addSubview: gameObject.view];
}
 */

- (void)redrawPalette {
    for (UIView *subview in palette.subviews) {
        [subview removeFromSuperview];
    }
        
    CGFloat padding = 20.;
    CGPoint center = CGPointMake(padding, palette.bounds.size.height / 2);
    
    // @synchronized (gameObjectsInPalette) {
    //     for (GameObject* object in gameObjectsInPalette) {
    for (GameObject* object in self.gameObjectsInPalette) {
            if (object.kGameObjectState == kGameObjectStateOnPalette) {
                [object.view setCenter: CGPointMake(center.x + object.defaultIconSize.width / 2, center.y)];
                [palette addSubview: object.view];
                
                center = CGPointMake(center.x + object.defaultIconSize.width + padding, center.y);
            }
        }
    // }
    
    [self checkRep];
}

- (void)setUpPalette {
    /*
    [self addGameObjectToPalette: kGameObjectWolf];
    [self addGameObjectToPalette: kGameObjectPig];
    [self addGameObjectToPalette: kGameObjectBlock];
    */
    [self addGameObjectToPalette: [GameObject GameObjectCreate: kGameObjectWolf]];
    [self addGameObjectToPalette: [GameObject GameObjectCreate: kGameObjectPig]];
    [self addGameObjectToPalette: [GameObject GameObjectCreate: kGameObjectBlock]];
    
    [self redrawPalette];
}

- (void) setUpGameArea {
    // load the images into UIImage objects
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
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    DLog(@"viewDidLoad called");
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    gameObjectsInGameArea_ = [NSMutableArray array];
    gameObjectsInPalette_ = [NSMutableArray array];
    
    [self setUpGameArea];
    [self setUpPalette];
}

- (void)viewDidUnload
{
    DLog(@"viewDidUnload called");
    [self setGameArea:nil];
    [self setPalette:nil];
    [self setPalette:nil];
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

- (IBAction)buttonPressed:(id)sender {
    UIColor *newColor;
    UIButton *button = (UIButton*)sender;
    if ([button titleColorForState:UIControlStateNormal] ==
        [UIColor blackColor]) {
        newColor = [UIColor lightGrayColor];
    } else {
        newColor = [UIColor blackColor];
    }
    [button setTitleColor:newColor forState:UIControlStateNormal];
}

- (IBAction)resetButtonPressed:(id)sender {
    DLog(@"Level builder is reset");
    
    // Clean up all items in the palette and the game area
    // @synchronized(gameObjectsInPalette) {
        for (GameObject* o in self.gameObjectsInPalette) {
            [o.view removeFromSuperview]; 
        }
    // }
    
    // @synchronized(gameObjectsInGameArea) {
        for (GameObject* o in self.gameObjectsInGameArea) {
            [o.view removeFromSuperview];
        }
    // }
    
    gameObjectsInGameArea_ = [NSMutableArray array];
    gameObjectsInPalette_ = [NSMutableArray array];

    [self setUpGameArea];
    [self setUpPalette];
}

@end
