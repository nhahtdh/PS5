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

typedef enum {kGameModeBuilder, kGameModePlay} GameMode;

@interface GameViewController : UIViewController {
    b2World *gameWorld;
    
    GameMode kGameMode;
    
    NSMutableArray *gameObjectsInGameArea;
    NSMutableArray *gameObjectsInPalette;
}

@property (readonly) GameMode kGameMode;

@property (strong, readonly) NSMutableArray *gameObjectsInGameArea;
@property (strong) IBOutlet UIScrollView *gameArea;

@property (strong, readonly) NSMutableArray *gameObjectsInPalette;
@property (strong) IBOutlet UIView *palette;

- (void) addGameObjectToPalette: (GameObject*) gameObject;

- (void) removeGameObjectFromPalette: (GameObject*) gameObject;

- (void) addGameObjectToGameArea: (GameObject*) gameObject;

- (void) removeGameObjectFromGameArea: (GameObject*) gameObject;

// - (void) hidePalette;

- (void) redrawPalette;

#pragma mark UIButton

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

- (IBAction)buttonPressed:(id)sender;

- (IBAction)resetButtonPressed:(id)sender;

- (IBAction)playButtonPressed:(id)sender;

@end
