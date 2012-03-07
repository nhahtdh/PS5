//
//  GameObject.h
// 
//

#import <UIKit/UIKit.h>
#import <Box2D/Box2D.h>
#import "Utilities.h"
// #import "ContactListenerProtocol.h"

typedef enum {kGameObjectWolf, kGameObjectPig, kGameObjectBlock, kGameObjectBreath} GameObjectType;

typedef enum {kGameObjectStateOnPalette, kGameObjectStateTransitFromPalette, kGameObjectStateOnGameArea} GameObjectState;

@interface GameObject : UIViewController <UIGestureRecognizerDelegate> {
    GameObjectState kGameObjectState;
    
    UIImageView* imageView;
    
    // Level builder model
    CGPoint center;
    CGFloat angle;
    CGFloat scale;
    
    // UI Interaction
    // TODO: This is possibly bloaty to place in GameObject
    UIPanGestureRecognizer *pan;
    CGPoint __startingPosition;
    
    UIRotationGestureRecognizer *rotate;
    CGFloat __previousRotation;
    
    UIPinchGestureRecognizer *pinch;
    CGFloat __previousScale;
    
    // In-play attributes
    b2Body *body;
    CGFloat damage;
}

- (id) init;

+ (GameObject*)GameObjectCreate: (GameObjectType) kGameObjectType;

#pragma mark GameObject view

@property (nonatomic, readonly) GameObjectState kGameObjectState;

@property (nonatomic, readonly) CGSize defaultImageSize;
@property (nonatomic, readonly) CGSize defaultIconSize;
@property (strong, nonatomic, readonly) UIImageView* imageView;

- (void) resize:(CGSize)sizes;

- (void) resetToPaletteIcon;

#pragma mark GameObject properties

@property (nonatomic, readonly) GameObjectType kGameObjectType;

@property (nonatomic, readonly) CGPoint center;
@property (nonatomic, readonly) CGFloat angle;
@property (nonatomic, readonly) CGFloat scale;

@property (nonatomic, readonly) CGFloat maxScale;
@property (nonatomic, readonly) CGFloat minScale;

@property (nonatomic, readonly) b2BodyDef bodyDef;
@property (nonatomic, readonly) b2Shape *shape;
// NOTE: Every time the shape is retrieved, the caller is responsible for destroying the object
@property (nonatomic, readonly) b2FixtureDef fixtureDef;

#pragma mark Game mechanics

@property (readwrite) b2Body *body;
@property (nonatomic, readonly) CGFloat damage;
// The total damage the object received.

- (BOOL)hasExpired;
// Returns whether the object has expired or not. An object expires when the damage it receives exceeds
// certain threshold, or by other conditions defined by subclasses.
// This condition will be used to determine whether to continue to simulate the object or not.
// REQUIRES: The GameObject is inside game area and the game is in play mode.

- (void)setUpForPlay;

- (void)setUpForBuilder;

- (void)applyDamage: (const b2ContactImpulse*) impulses;
// REQUIRES: This function should only be called from a subclass of b2ContactListener to apply damage
//           to the GameObject.

- (void)updateView;

#pragma mark Gestures

@property (nonatomic, readonly) BOOL canTranslate;
@property (nonatomic, readonly) BOOL canRotate;
@property (nonatomic, readonly) BOOL canZoom;

@end
