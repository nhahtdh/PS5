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

/*
+ (NSString*) getBlockImageFileName: (GameBlockType) blockType {
    return kBlockImageFileNames[blockType];
}
 */

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
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(changeBlockType:)];
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
    assert(kGameObjectState == kGameObjectStateOnGameArea);
    
    b2BodyDef bodyDef;
    bodyDef.position.Set(pixelToMeter(self.view.center.x), pixelToMeter(self.view.center.y));
    bodyDef.type = b2_dynamicBody;
    bodyDef.angle = self.angle;
    return bodyDef;
}

// TODO: Check whether this funciton return properly or not
- (b2Shape) shape {
    // REQUIRES: This function should only be called after it is confirmed that the game should start.
    // The object should also be properly inside the game area.
    assert(kGameObjectState == kGameObjectStateOnGameArea);
    
    b2PolygonShape shape;
    shape.SetAsBox(pixelToMeter(self.scale * self.defaultImageSize.width) / 2., pixelToMeter(self.scale * self.defaultImageSize.height) / 2.);
    
    return shape;
}

// TODO: Check whether this funciton return properly or not
- (b2FixtureDef) fixtureDef {
    // REQUIRES: This function should only be called after it is confirmed that the game should start.
    // The object should also be properly inside the game area.
    assert(kGameObjectState == kGameObjectStateOnGameArea);
    
    // TODO: Fill in this function
    switch (self.kGameBlockType) {
        case kGameBlockStraw:
            break;
        case kGameBlockStone:
            break;
        case kGameBlockWood:
            break;
        case kGameBlockIron:
            break;
        default:
            @throw [NSException exceptionWithName: @"Not implemented exception"
                                          reason: @"Unimplemented game block"
                                        userInfo: nil];
    }
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
    // [imageView setImage: [UIImage imageNamed: [GameBlock getBlockImageFileName: self.kGameBlockType]]];
    [imageView setImage: [GameBlock getImage: self.kGameBlockType]];
}

#pragma mark - View life cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    DLog(@"Block viewDidLoad called.");
    
    [super.view setAutoresizesSubviews:YES];
    
    self.kGameBlockType = kGameBlockStraw;
    // UIImage *blockImage = [UIImage imageNamed: [GameBlock getBlockImageFileName: self.kGameBlockType]];
    // imageView = [[UIImageView alloc] initWithImage:blockImage];
    UIImage *blockImage = [GameBlock getImage: self.kGameBlockType];
    imageView = [[UIImageView alloc] initWithImage: blockImage];
    
    [self.view addSubview: imageView];
    [self.view setFrame: CGRectMake(0, 0, blockImage.size.width, blockImage.size.height)];
    [self.view setBackgroundColor: [UIColor clearColor]];
}
@end
