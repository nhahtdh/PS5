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

+ (UIImage*) getPigImage {
    static UIImage* pigNormal;
    if (pigNormal == nil) {
        pigNormal = [UIImage imageNamed: @"pig.png"];
    }
    return pigNormal;
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
    
    fixtureDef.density = 1.5;
    fixtureDef.friction = 0.8;
    fixtureDef.restitution = 0.0;
    
    return fixtureDef;
}

#pragma mark - Gestures

-(BOOL) canTranslate {
    return YES;
}

-(BOOL) canRotate {
    return NO;
}

-(BOOL) canZoom {
    return YES;
}

-(CGFloat) maxScale {
    return 1.5;
}

-(CGFloat) minScale {
    return 0.8;
}

#pragma mark - Game mechanics

- (BOOL) hasExpired {
    return damage > 60.;
}

- (void) updateView {
    [super updateView];
    
    if (self.damage > 30.) {
        self.imageView.image = [UIImage imageNamed: @"pig2.png"];
    } else if ([self hasExpired]) {
        self.view.hidden = YES;
        /*
        self.view.hidden = NO;
        
        self.imageView.animationImages = imageToFrames(@"pig-die-smoke.png", 5, 2);
        self.imageView.animationDuration = 0.8;
        self.imageView.animationRepeatCount = 1;
        
        self.imageView.image = [self.imageView.animationImages lastObject];
        [self.imageView sizeToFit];
        [self resize: self.imageView.image.size];
        
        b2Vec2 position = self.body->GetPosition();
        self.view.center = CGPointMake(meterToPixel(position.x), meterToPixel(position.y));
        
        [self.imageView startAnimating];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            self.view.hidden = YES;
        });
         */
    }
}

- (void) setUpForBuilder {
    [super setUpForBuilder];
    
    self.imageView.image = [GamePig getPigImage];
    // self.imageView.animationImages = nil;
}

#pragma mark - View life cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // Set up view
    [self.view setAutoresizesSubviews: YES];
    
    UIImage *pigImage = [GamePig getPigImage];
    imageView = [[UIImageView alloc] initWithImage: pigImage];
    
    // self.imageView.animationDuration = 0.4;
    // self.imageView.animationRepeatCount = 1;
    
    [self.view addSubview: imageView];
    [self.view setBackgroundColor: [UIColor clearColor]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
