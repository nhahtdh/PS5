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
    static UIImage* gameBlockImages[4];
    if (gameBlockImages[kGameBlockType] == nil) {
        gameBlockImages[kGameBlockType] = [UIImage imageNamed: kBlockImageFileNames[kGameBlockType]];
    }

    return gameBlockImages[kGameBlockType];
}

- (void) setNextBlockType {
    // TODO: This is kinda hard-coded: the number of types of blocks
    self.kGameBlockType = (GameBlockType) ((self.kGameBlockType + 1) % 4);
}

- (id) init {
    if (self = [super init]) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(changeBlockType:)];
        [tap setNumberOfTapsRequired: 1];
        [tap setNumberOfTouchesRequired: 1];
        
        [self.view addGestureRecognizer: tap];
    }
    
    return self;
}

// TODO: Check whether this function return properly or not
- (b2BodyDef) bodyDef {
    // REQUIRES: This function should only be called after it is confirmed that the game should start.
    // The object should also be properly inside the game area.
    assert(self.kGameObjectState == kGameObjectStateOnGameArea);
    
    b2BodyDef bodyDef;
    bodyDef.position.Set(pixelToMeter(self.view.center.x), pixelToMeter(self.view.center.y));
    bodyDef.type = b2_dynamicBody;
    bodyDef.angle = self.angle;
    return bodyDef;
}

// TODO: Check whether this funciton return properly or not
- (b2FixtureDef) fixtureDef {
    // REQUIRES: This function should only be called after it is confirmed that the game should start.
    // The object should also be properly inside the game area.
    assert(self.kGameObjectState == kGameObjectStateOnGameArea);
    
    b2FixtureDef fixtureDef;
    
    switch (self.kGameBlockType) {
        case kGameBlockStraw:
            fixtureDef.density = 1.75;
            fixtureDef.friction = 0.7;
            fixtureDef.restitution = 0.15;
            break;
        case kGameBlockWood:
            fixtureDef.density = 5;
            fixtureDef.friction = 0.6;
            fixtureDef.restitution = 0.3;
            break;
        case kGameBlockIron:
            fixtureDef.density = 12;
            fixtureDef.friction = 0.4;
            fixtureDef.restitution = 0.1;
            break;
        case kGameBlockStone:
            fixtureDef.density = 16;
            fixtureDef.friction = 0.5;
            fixtureDef.restitution = 0.1;
            break;
        default:
            @throw [NSException exceptionWithName: @"Not implemented exception"
                                          reason: @"Unimplemented game block"
                                        userInfo: nil];
    }
    
    return fixtureDef;
}

- (CGSize) defaultImageSize {
    static const CGSize size = CGSizeMake(30, 130);
    return size;
}

- (CGSize) defaultIconSize {
    static const CGSize size = CGSizeMake(100, 100);
    return size;
}

- (GameObjectType) kGameObjectType {
    return kGameObjectBlock;
}

- (void) setUpForPlay {
    [super setUpForPlay];
    tap.enabled = NO;
}

- (void) setUpForBuilder {
    [super setUpForBuilder];
    
    tap.enabled = YES;
}

#pragma mark Gestures

- (BOOL) canTranslate {
    return YES;
}

- (BOOL) canRotate {
    return self.kGameObjectState == kGameObjectStateOnGameArea;
}

- (BOOL) canZoom {
    return self.kGameObjectState == kGameObjectStateOnGameArea;
}

- (void) changeBlockType:(UIGestureRecognizer *)gesture {
    DLog(@"Tap");
    if (![gesture isMemberOfClass: [UITapGestureRecognizer class]]) {
        DLog(@"WARNING: Something is wrong here");
    }
    
    [self setNextBlockType];
    [imageView setImage: [GameBlock getImage: self.kGameBlockType]];
}

#pragma mark - View life cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    DLog(@"Block viewDidLoad called.");
    
    [super.view setAutoresizesSubviews:YES];
    
    self.kGameBlockType = kGameBlockStraw;
    
    UIImage *blockImage = [GameBlock getImage: self.kGameBlockType];
    imageView = [[UIImageView alloc] initWithImage: blockImage];
    
    [self.view addSubview: imageView];
    [self.view setFrame: CGRectMake(0, 0, blockImage.size.width, blockImage.size.height)];
    [self.view setBackgroundColor: [UIColor clearColor]];
}
@end
