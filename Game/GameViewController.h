//
//  ViewController.h
//  Game
//
//  Created by  on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// #import <Box2D/Box2D.h>
#import "GameObject.h"

typedef enum {kLevelBuilderMode, kPlayMode} GameMode;

@interface GameViewController : UIViewController {
    // GameEngine * gameEngine;
    
    GameMode kGameMode;
    
    NSMutableArray *gameObjectsInGameArea;
    NSMutableArray *gameObjectsInPalette;
}

- (IBAction)buttonPressed:(id)sender;

- (IBAction)resetButtonPressed:(id)sender;

@property (strong, readonly) NSMutableArray *gameObjectsInGameArea;
@property (strong) IBOutlet UIScrollView *gameArea;

@property (strong, readonly) NSMutableArray *gameObjectsInPalette;
@property (strong) IBOutlet UIView *palette;

- (void) addGameObjectToPalette: (GameObject*) gameObject;

- (void) removeGameObjectFromPalette: (GameObject*) gameObject;

- (void) addGameObjectToGameArea: (GameObject*) gameObject;

- (void) removeGameObjectFromGameArea: (GameObject*) gameObject;

- (void) redrawPalette;

@end
