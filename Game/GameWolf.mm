//
//  GameWolf.m
//  Game
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameWolf.h"

@implementation GameWolf

-(GameObjectType) kGameObjectType {
    return kGameObjectWolf;
}

- (CGSize) defaultImageSize {
    static const CGSize size = CGSizeMake(225, 150);
    return size;
}

- (CGSize) defaultIconSize {
    static const CGSize size = CGSizeMake(150, 100);
    return size;
}

+ (CGRect) getBoundingBoxAt: (int) frameNumber {
    // REQUIRE: 0 <= frameNumber < total number of frames in wolfs.png
    //          The numbering starts from top-left corner, from left-to-right,
    //          then top-to-bottom
    // EFFECTS: return a CGRect that represents the specified frame of the wolf
    
    CGFloat singleFrameWidth = 225;
    CGFloat singleFrameHeight = 150;
    int framePerRow = 5;
    int framePerColumn = 3;
    
    int numberOfFrames = framePerColumn * framePerRow;
    
    assert(frameNumber >= 0 && frameNumber < numberOfFrames);
    // if (frameNumber < 0 || frameNumber >= numberOfFrames)
    //     [NSException raise:@"Invalid frame number" 
    //                 format:@"Frame number %d does not exist", (int) frameNumber];
    
    CGFloat xCoordinate = singleFrameWidth * (frameNumber % framePerRow);
    CGFloat yCoordinate = singleFrameHeight * (frameNumber / framePerRow);
    
    return CGRectMake(xCoordinate, yCoordinate, singleFrameWidth, singleFrameHeight);
}

// TODO: Wolf alive and wolf die
+ (NSArray*) getWolfImages {
    static NSArray* wolfAliveFrames;
    
    if (wolfAliveFrames == nil) {
        CGImageRef wolfAliveImage = [[UIImage imageNamed: @"wolfs.png"] CGImage];
        int numberOfFrames = 15;
        
        NSMutableArray* a = [NSMutableArray array];
        
        for (int i = 0; i < numberOfFrames; i++) {
            UIImage* frame = [UIImage imageWithCGImage:
                              CGImageCreateWithImageInRect(wolfAliveImage, [GameWolf getBoundingBoxAt: i])];
            [a addObject: frame];
        }
        
        wolfAliveFrames = [NSArray arrayWithArray: a];
    }
    
    return wolfAliveFrames;
}

#pragma mark Gestures

-(BOOL) canTranslate {
    return YES;
}

-(BOOL) canRotate {
    return NO;
}

-(BOOL) canZoom {
    return NO;
}

#pragma mark - View life cycle

-(void) viewDidLoad {
    [super viewDidLoad];
    
    DLog(@"Wolf viewDidLoad called.");
    
    [self.view setAutoresizesSubviews: YES];

    // Get the first frame of the wolf image
    UIImage *wolfImage = [[GameWolf getWolfImages] objectAtIndex: 0];
    
    // Configure the image view that contain the wolf image
    imageView = [[UIImageView alloc] initWithImage: wolfImage];
    
    [self.view addSubview: imageView];
    [self.view setFrame: CGRectMake(0, 0, wolfImage.size.width, wolfImage.size.height)];
    [self.view setBackgroundColor: [UIColor clearColor]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
