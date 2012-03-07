//
//  GameBlock.m
//  Game
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameBlock.h"

NSString* const kBlockImageFileNames[] =  {@"straw.png", @"wood.png", @"iron.png", @"stone.png"};

@implementation GameBlock

@synthesize kGameBlockType;

+ (UIImage*) getImage: (GameBlockType) kGameBlockType {
    static UIImage* gameBlockImages[NUM_BLOCK_TYPE];
    if (gameBlockImages[kGameBlockType] == nil) {
        gameBlockImages[kGameBlockType] = [UIImage imageNamed: kBlockImageFileNames[kGameBlockType]];
    }

    return gameBlockImages[kGameBlockType];
}

- (b2Shape*) shape {
    // REQUIRES: This function should only be called after it is confirmed that the game should start.
    // The object should also be properly inside the game area.
    assert(self.kGameObjectState == kGameObjectStateOnGameArea);
    
    b2PolygonShape *shape = new b2PolygonShape();
    shape->SetAsBox(pixelToMeter(self.scale * self.defaultImageSize.width) / 2., 
                    pixelToMeter(self.scale * self.defaultImageSize.height) / 2.);
    
    return shape;
}

- (b2FixtureDef) fixtureDef {
    // REQUIRES: This function should only be called after it is confirmed that the game should start.
    // The object should also be properly inside the game area.
    assert(self.kGameObjectState == kGameObjectStateOnGameArea);
    
    b2FixtureDef fixtureDef;
    
    switch (self.kGameBlockType) {
        case kGameBlockStraw:
            fixtureDef.density = 1.5;
            fixtureDef.friction = 0.7;
            fixtureDef.restitution = 0.15;
            break;
        case kGameBlockWood:
            fixtureDef.density = 3;
            fixtureDef.friction = 0.6;
            fixtureDef.restitution = 0.2;
            break;
        case kGameBlockIron:
            fixtureDef.density = 6;
            fixtureDef.friction = 0.4;
            fixtureDef.restitution = 0.1;
            break;
        case kGameBlockStone:
            fixtureDef.density = 8;
            fixtureDef.friction = 0.5;
            fixtureDef.restitution = 0.05;
            break;
        default:
            @throw [NSException exceptionWithName: @"Not implemented exception"
                                           reason: @"Unimplemented game block"
                                         userInfo: nil];
    }
    
    return fixtureDef;
}

- (CGSize) defaultImageSize {
    return CGSizeMake(30, 130);
}

- (CGSize) defaultIconSize {
    return CGSizeMake(100, 100);
}

- (CGFloat) maxScale {
    return 3.;
}

- (CGFloat) minScale {
    return 0.75;
}

- (GameObjectType) kGameObjectType {
    return kGameObjectBlock;
}

#pragma mark - Game mechanics

- (void) setUpForPlay {
    [super setUpForPlay];
    tap.enabled = NO;
}

- (void) setUpForBuilder {
    [super setUpForBuilder];
    
    tap.enabled = YES;
}

- (void) applyDamage:(const b2ContactImpulse *)impulses {
    [super applyDamage: impulses];
    
    // DLog(@"Accummulated damage: %d %f", self.kGameBlockType, damage);
}

#pragma mark - Gestures

- (BOOL) canTranslate {
    return YES;
}

- (BOOL) canRotate {
    return self.kGameObjectState == kGameObjectStateOnGameArea;
}

- (BOOL) canZoom {
    return self.kGameObjectState == kGameObjectStateOnGameArea;
}

- (void) changeBlockType:(UITapGestureRecognizer *)gesture {
    // MODIFIES: object model (block type)
    // REQUIRES: game in designer mode
    // EFFECTS: the object changes block type
    
    self.kGameBlockType = (GameBlockType) ((self.kGameBlockType + 1) % NUM_BLOCK_TYPE);
    [imageView setImage: [GameBlock getImage: self.kGameBlockType]];
}

#pragma mark - View life cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // Set up extra gesture
    tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(changeBlockType:)];
    [tap setNumberOfTapsRequired: 1];
    [tap setNumberOfTouchesRequired: 1];
    
    [self.view addGestureRecognizer: tap];
    
    // Set up view
    [self.view setAutoresizesSubviews:YES];
    
    self.kGameBlockType = kGameBlockStraw;
    
    UIImage *blockImage = [GameBlock getImage: self.kGameBlockType];
    imageView = [[UIImageView alloc] initWithImage: blockImage];
    
    [self.view addSubview: imageView];
    [self.view setBackgroundColor: [UIColor clearColor]];
}
@end
