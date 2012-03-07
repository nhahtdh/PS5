//
//  ViewController.h
//  Game
//
//  Created by  on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Box2D/Box2D.h>
#import "GameObject.h"
#import "GameBreath.h"
#import "ContactListener.mm"

typedef enum {kGameModeBuilder, kGameModePlay} GameMode;

#define UPDATES_PER_SECOND 60.
#define DEFAULT_TIME_STEP (1 / 60.)

#define DEFAULT_VELOCITY_ITERATIONS 8
#define DEFAULT_POSITION_ITERATIONS 6

@interface GameViewController : UIViewController {
    GameMode kGameMode;
    
    NSMutableArray *gameObjectsInGameArea;
    NSMutableArray *gameObjectsInPalette;
    
    b2World *gameWorld;
    ContactListener *contactListener;
    NSTimer *updateTimer;
}

@property (readonly) GameMode kGameMode;

@property (strong, readonly) NSMutableArray *gameObjectsInGameArea;
@property (strong, nonatomic) IBOutlet UIScrollView *gameArea;

@property (strong, readonly) NSMutableArray *gameObjectsInPalette;
@property (strong, nonatomic) IBOutlet UIView *palette;

- (void) addGameObjectToPalette: (GameObject*) gameObject;

- (void) removeGameObjectFromPalette: (GameObject*) gameObject;

- (void) redrawPalette;

- (void) createBreath: (b2Vec2) power from: (CGPoint) position;

#pragma mark UIButton

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

- (IBAction)buttonPressed:(id)sender;

- (IBAction)resetButtonPressed:(id)sender;

- (IBAction)playButtonPressed:(id)sender;

@end
