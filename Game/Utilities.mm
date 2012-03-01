//
//  Utilities.cpp
//  Game
//
//  Created by  on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

#define PIXEL_PER_METER 50.

double meterToPixel(double x) {
    return x * PIXEL_PER_METER;
}

double pixelToMeter(double x) {
    return x / PIXEL_PER_METER;
}

NSArray* imageToFrames(NSString* imageName, CGSize frameSize) {
    UIImage *image = [UIImage imageNamed: imageName];
    CGSize imageSize = image.size;
    
    int framePerRow = (int) floor(imageSize.height / frameSize.height + .5);
    int framePerColumn = (int) floor(imageSize.width / frameSize.width + .5);

    int numberOfFrames = framePerColumn * framePerRow;
    
    
    CGImageRef imageRef = [[UIImage imageNamed: imageName] CGImage];
    
    NSMutableArray *frames = [NSMutableArray array];
    
    for (int i = 0; i < numberOfFrames; i++) {
        CGFloat xCoordinate = frameSize.width * (i % framePerRow);
        CGFloat yCoordinate = frameSize.height * (i / framePerRow);
        
        CGRect boundingBox = CGRectMake(xCoordinate, yCoordinate, frameSize.width, frameSize.height);
        
        UIImage* singleFrame = [UIImage imageWithCGImage: 
                                CGImageCreateWithImageInRect(imageRef,  boundingBox)];
        
        [frames addObject: singleFrame];
    }
    
    return [NSArray arrayWithArray: frames];
}
