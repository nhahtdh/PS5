//
//  GamePig.m
//  Game
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GamePig.h"

@implementation GamePig

-(GameObjectType) kGameObjectType {
    return kGameObjectPig;
}

- (CGSize) defaultImageSize {
    return CGSizeMake(88, 88);
}

- (CGSize) defaultIconSize {
    return CGSizeMake(100, 100);
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

#pragma mark - View life cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    DLog(@"Pig viewDidLoad called.");
    
    [self.view setAutoresizesSubviews: YES];
    
    UIImage *pigImage = [UIImage imageNamed:@"pig.png"];
    // UIImageView *pigImageView = [[UIImageView alloc] initWithImage: pigImage];
    imageView = [[UIImageView alloc] initWithImage: pigImage];
    
    // [self.view addSubview: pigImageView];
    [self.view addSubview: imageView];
    [self.view setFrame: CGRectMake(0, 0, pigImage.size.width, pigImage.size.height)];
    [self.view setBackgroundColor: [UIColor clearColor]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
