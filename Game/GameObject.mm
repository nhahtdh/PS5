//
//  GameObject.m
// 

#import "GameViewController.h"

#import "GameObject.h"
#import "GameWolf.h"
#import "GamePig.h"
#import "GameBlock.h"
#import "GameBreath.h"

@implementation GameObject

@synthesize kGameObjectState = kGameObjectState_;
@dynamic kGameObjectType;

@dynamic defaultImageSize;
@dynamic defaultIconSize;
@synthesize imageView;

@synthesize body;

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

@dynamic shape;
@dynamic fixtureDef;

@synthesize center = center_;
@synthesize angle = angle_;
@synthesize scale = scale_;

- (CGFloat) maxScale {
    return 5.;
}

- (CGFloat) minScale {
    return 0.25;
}

+ (GameObject*) GameObjectCreate:(GameObjectType)kGameObjectType {
    switch (kGameObjectType) {
        case kGameObjectWolf:
            return [[GameWolf alloc] init];
        case kGameObjectPig:
            return [[GamePig alloc] init];
        case kGameObjectBlock:
            return [[GameBlock alloc] init];
        case kGameObjectBreath:
            @throw [NSException exceptionWithName: @"Invalid initialization"
                                           reason: @"GameBreath object should be not be initialized with this function"
                                         userInfo: nil];
        default:
            return nil;
    }
}

-(id) init {
    DLog(@"GameObject init is called: %@", self);
    if (self = [super init]) {
        angle_ = 0.0;
        scale_ = 1.0;
    }
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    DLog(@"GameObject initWithCoder is called");
    if (self = [super initWithCoder: aDecoder]) {
        // TODO: Implement this later
    }
    
    return self;
}

- (void) resize:(CGSize)sizes {
    [self.imageView setFrame: CGRectMake(self.imageView.frame.origin.x, 
                                         self.imageView.frame.origin.y,
                                         sizes.width,
                                         sizes.height)];
    [self.view setFrame: CGRectMake(self.view.frame.origin.x,
                                    self.view.frame.origin.y,
                                    sizes.width,
                                    sizes.height)];
}

- (void) resetToPaletteIcon {
    // EFFECTS: This method will reset all the scaling and rotation of the object,
    //          set its size to the default icon size and set its state to be on
    //          the palette.
    // USAGE: This function is to be called to reset the object back to initial
    //        state. It is expected that the game object is added to the palette
    //        after this function is called.
    kGameObjectState_ = kGameObjectStateOnPalette;
    [self resize: self.defaultIconSize];
    [self.view setTransform: CGAffineTransformIdentity];
    angle_ = 0.0;
    scale_ = 1.0;
}

#pragma mark - Game mechanics

- (void) setUpForPlay {
    pan.enabled = NO;
    rotate.enabled = NO;
    pinch.enabled = NO;
    
    center_ = self.view.center;
    
    damage = 0;
}

- (void) setUpForBuilder {
    pan.enabled = YES;
    rotate.enabled = YES;
    pinch.enabled = YES;
    
    self.view.center = self.center;
    [self.view setTransform: CGAffineTransformScale(CGAffineTransformMakeRotation(self.angle), self.scale, self.scale)];
    
    damage = 0;
}

- (BOOL) hasExpired {
    return NO;
}

@synthesize damage;

- (void) applyDamage:(const b2ContactImpulse *)impulses {
    CGFloat curr = (impulses->normalImpulses[0] + impulses->normalImpulses[1]) / self.body->GetMass();
    // DLog(@"Normalized damage on %@: %f", self, curr);
    if (curr > 1)
        damage += curr;
    
    // DLog(@"Accummulated damage: %@ %f", self, damage);
}

- (void) updateView {
    assert(body != nil);
    [self.view setTransform: CGAffineTransformRotate(CGAffineTransformMakeScale(self.scale, self.scale), body->GetAngle())];
    
    const b2Vec2 &position = body->GetPosition();
    [self.view setCenter: CGPointMake(meterToPixel(position.x), meterToPixel(position.y))];
    
    if ([self hasExpired]) {
        self.view.hidden = YES;
    }
}

#pragma mark View lifecycle

-(void) viewDidLoad {
    [super viewDidLoad];
    
    DLog(@"%@ viewDidLoad called", [self class]);
    
    // TODO: Should this be specific to each of the object? To save space and probably make more sense
    // since not all objects can be placed in the game area anyway.
    pan = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(translate:)];
    [pan setMinimumNumberOfTouches: (NSUInteger) 1];
    [pan setMaximumNumberOfTouches: (NSUInteger) 1];
    [pan setDelaysTouchesBegan: 0.1];
    [pan setDelegate: self];
    
    pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action: @selector(zoom:)];
    [pinch setDelaysTouchesBegan: 0.1];
    [pinch setDelegate: self];
    
    rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action: @selector(rotate:)];
    [rotate setDelaysTouchesBegan: 0.1];
    [rotate setDelegate: self];
    
    [self.view addGestureRecognizer: pan];
    [self.view addGestureRecognizer: pinch];
    [self.view addGestureRecognizer: rotate];
}

#pragma mark Gestures

-(BOOL) canTranslate {
    return YES;
}

-(BOOL) canRotate {
    return YES;
}

-(BOOL) canZoom {
    return YES;
}

-(void) translate:(UIPanGestureRecognizer *)gesture {
    // MODIFIES: object model (position)
    // REQUIRES: game in designer mode
    // EFFECTS: the user drags around the object with one finger
    //          if the object is in the palette, it will be moved in the game area
    
    DLog(@"Pan gesture detected on %@", self);
    
    if ([self canTranslate]) {
        GameViewController *gameViewController = (GameViewController*) self.parentViewController;
        if ([gesture state] == UIGestureRecognizerStateBegan) {
            // Change ref. frame of center point from superview of object to the root view
            __startingPosition = [gameViewController.view convertPoint: self.view.center fromView: self.view.superview];
            
            // Place the object in the root view
            [gameViewController.view addSubview: self.view];
            
            // Scale the object to default size and set state if from the palette
            if (self.kGameObjectState == kGameObjectStateOnPalette) {
                [self resize: self.defaultImageSize];
                kGameObjectState_ = kGameObjectStateTransitFromPalette;
            }
        }
        
        CGPoint delta = [gesture translationInView: self.view.superview];
        // DLog(@"Delta: %f %f", delta.x, delta.y);
        CGPoint translatedCenter = CGPointMake(__startingPosition.x + delta.x, __startingPosition.y + delta.y);
        DLog(@"%@ center: %f %f", [self class], translatedCenter.x, translatedCenter.y);
        DLog(@"%@ state: %d", self, self.kGameObjectState);
        [self.view setCenter: translatedCenter];
         
        if ([gesture state] == UIGestureRecognizerStateEnded ||
            [gesture state] == UIGestureRecognizerStateCancelled) {
            // Note: The gesture is cancelled when the notification bar is activated.
            CGPoint centerRelativeToGameArea = [gameViewController.gameArea convertPoint: translatedCenter fromView:gameViewController.view];
            
            // The object lands inside game area
            if ([gameViewController.gameArea pointInside: centerRelativeToGameArea withEvent: nil]) {
                DLog(@"Center (%f, %f) is inside game area", centerRelativeToGameArea.x, centerRelativeToGameArea.y);
                
                // Place the object into game area and adjust the center accordingly
                [gameViewController.gameArea addSubview: self.view];
                [self.view setCenter: centerRelativeToGameArea];
                
                if (self.kGameObjectState == kGameObjectStateTransitFromPalette) {
                    [gameViewController.gameObjectsInGameArea addObject: self];
                    [gameViewController removeGameObjectFromPalette: self];
                    if (self.kGameObjectType == kGameObjectBlock) {
                        [gameViewController addGameObjectToPalette: [GameObject GameObjectCreate: kGameObjectBlock]];
                    }
                    kGameObjectState_ = kGameObjectStateOnGameArea;
                    [gameViewController redrawPalette];
                }
                
            } 
            // The object lands outside game area
            else {
                DLog(@"Center (%f, %f) is outside game area", centerRelativeToGameArea.x, centerRelativeToGameArea.y);
                [UIView beginAnimations: @"Object lands outside gamearea" context: nil];
                [UIView setAnimationDuration: 0.2];
                
                switch (self.kGameObjectState) {
                    case kGameObjectStateTransitFromPalette:
                        kGameObjectState_ = kGameObjectStateOnPalette;
                        [gameViewController redrawPalette];
                        break;
                    case kGameObjectStateOnGameArea:
                        if (self.kGameObjectType == kGameObjectPig || self.kGameObjectType == kGameObjectWolf) {
                            kGameObjectState_ = kGameObjectStateOnPalette;
                            [gameViewController addGameObjectToPalette: self];
                            [gameViewController.gameObjectsInGameArea removeObject: self];
                            [gameViewController redrawPalette];
                        } else if (self.kGameObjectType == kGameObjectBlock) {
                            [self removeFromParentViewController];
                            [self.view removeFromSuperview];
                            [gameViewController.gameObjectsInGameArea removeObject: self];
                        }
                        break;
                    case kGameObjectStateOnPalette:
                        @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                                       reason: @"Impossible state for a moving object" userInfo:nil];
                }
                
                [UIView commitAnimations];
            }
        }
    } else {
        DLog(@"Translation rejected");
    }
}

-(void) zoom:(UIPinchGestureRecognizer *)gesture {
    // MODIFIES: object model (scale)
    // REQUIRES: game in designer mode, object in game area
    // EFFECTS: the object is scaled up/down with a pinch gesture
    
    DLog(@"Pinch gesture detected on %@ object", [self class]);
    if ([self canZoom]) {
        DLog(@"Scale: %f", [gesture scale]);
        if ([gesture state] == UIGestureRecognizerStateBegan) {
            __previousScale = self.scale;
        }
        
        CGFloat currentScale = MAX(MIN([gesture scale] * self.scale, self.maxScale), self.minScale);  
        CGFloat scaleStep = currentScale / __previousScale;
        [self.view setTransform: CGAffineTransformScale(self.view.transform, scaleStep, scaleStep)];
        
        __previousScale = currentScale;
        
        if ([gesture state] == UIGestureRecognizerStateEnded) {
            scale_ = currentScale;
            DLog(@"Final scale: %f", scale_);
        }
        
        
        if ([gesture state] == UIGestureRecognizerStateCancelled ||
            [gesture state] == UIGestureRecognizerStateFailed) {
            DLog(@"WARNING: Gesture failed or cancelled");
        }
    } else {
        DLog(@"Zooming rejected on %@ object", [self class]);
    }
}

-(void) rotate:(UIRotationGestureRecognizer *)gesture {
    // MODIFIES: object model (rotation)
    // REQUIRES: game in designer mode, object in game area
    // EFFECTS: the object is rotated with a two-finger rotation gesture
    
    DLog(@"Rotation gesture detected on %@ object", [self class]);
    if ([self canRotate]) {
        if ([gesture state] == UIGestureRecognizerStateBegan) {
            __previousRotation = 0.0;
        }
        
        CGFloat rotationalChange = [gesture rotation] - __previousRotation;
        // self.angle += rotationalChange;
        [self.view setTransform: CGAffineTransformRotate(self.view.transform, rotationalChange)];

        __previousRotation = [gesture rotation];
        
        if ([gesture state] == UIGestureRecognizerStateEnded) {
            angle_ += [gesture rotation];
            // Limit the angle to [0, 2 * PI)
            angle_ -= floor(self.angle / M_PI / 2) * M_PI * 2;
            
            DLog(@"Delta: %f", [gesture rotation]);
            DLog(@"Final angle: %f", self.angle / M_PI * 180);
        }
        
        if ([gesture state] == UIGestureRecognizerStateCancelled ||
            [gesture state] == UIGestureRecognizerStateFailed) {
            DLog(@"WARNING: Gesture failed or cancelled");
        }
    } else {
        DLog(@"Rotation rejected on %@ object", [self class]);
    }
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    DLog(@"Simultaneous gestures occured: %@ %@", [gestureRecognizer class], [otherGestureRecognizer class]);

    // Only allow pinch and rotation gestures to work together
    if (([gestureRecognizer isKindOfClass: [UIPinchGestureRecognizer class]] &&
         [otherGestureRecognizer isKindOfClass: [UIRotationGestureRecognizer class]]) || 
        ([gestureRecognizer isKindOfClass: [UIRotationGestureRecognizer class]] &&
         [otherGestureRecognizer isKindOfClass: [UIPinchGestureRecognizer class]])) {
            return YES;
    }
    
    return NO;
}

@end