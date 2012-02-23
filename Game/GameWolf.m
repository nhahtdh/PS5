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
    return CGSizeMake(225, 150);
}

- (CGSize) defaultIconSize {
    return CGSizeMake(150, 100);
}

-(BOOL) canTranslate {
    return YES;
}

-(BOOL) canRotate {
    return NO;
}

-(BOOL) canZoom {
    return NO;
}

+ (CGRect) getBoundingBoxAt: (NSInteger)frameNumber {
    // REQUIRE: 0 <= frameNumber < total number of frames in wolfs.png
    //          The numbering starts from top-left corner, from left-to-right,
    //          then top-to-bottom
    // EFFECTS: return a CGRect that represents the specified frame of the wolf
    CGFloat singleFrameWidth = 225;
    CGFloat singleFrameHeight = 150;
    NSInteger framePerRow = 5;
    NSInteger framePerColumn = 3;
    
    NSInteger numberOfFrame = framePerColumn * framePerRow;
    
    if (frameNumber < 0 || frameNumber >= numberOfFrame)
        [NSException raise:@"Invalid frame number" 
                    format:@"Frame number %d does not exist", (int) frameNumber];
    
    CGFloat xCoordinate = singleFrameWidth * (frameNumber % framePerRow);
    CGFloat yCoordinate = singleFrameHeight * (frameNumber / framePerRow);
    
    return CGRectMake(xCoordinate, yCoordinate, singleFrameWidth, singleFrameHeight);
}

#pragma mark - View life cycle

-(void) viewDidLoad {
    [super viewDidLoad];
    
    DLog(@"Wolf viewDidLoad called.");
    
    [self.view setAutoresizesSubviews: YES];

    // Crop the image to the first frame
    UIImage *wolfImages = [UIImage imageNamed:@"wolfs.png"];
    CGRect frameZeroBoundingBox = [GameWolf getBoundingBoxAt: 0];
    UIImage *wolfImagesFirstFrame = [UIImage imageWithCGImage:
                                     CGImageCreateWithImageInRect([wolfImages CGImage], frameZeroBoundingBox)];
    
    // Configure the image view that contain the wolf image
    // UIImageView *wolfImageView = [[UIImageView alloc] initWithImage: wolfImagesFirstFrame];
    imageView = [[UIImageView alloc] initWithImage: wolfImagesFirstFrame];
    
    // [self.view addSubview: wolfImageView];
    [self.view addSubview: imageView];
    [self.view setFrame: CGRectMake(0, 0, wolfImagesFirstFrame.size.width, wolfImagesFirstFrame.size.height)];
    [self.view setBackgroundColor: [UIColor clearColor]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
