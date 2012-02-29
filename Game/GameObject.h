//
//  GameObject.h
// 
//

#import <UIKit/UIKit.h>
#import <Box2D/Box2D.h>
#import "Utilities.h"

typedef enum {kGameObjectWolf, kGameObjectPig, kGameObjectBlock} GameObjectType;

typedef enum {kGameObjectStateOnPalette, kGameObjectStateTransitFromPalette, kGameObjectStateOnGameArea} GameObjectState;

@interface GameObject : UIViewController <UIGestureRecognizerDelegate> {
    GameObjectState kGameObjectState;
    
    UIImageView* imageView;
    
    // Level builder model
    CGPoint center;
    CGFloat angle;
    CGFloat scale;
    CGAffineTransform baseTransform;
    
    // UI Interaction
    UIPanGestureRecognizer *pan;
    CGPoint __startingPosition;
    
    UIRotationGestureRecognizer *rotate;
    CGFloat __previousRotation;
    
    UIPinchGestureRecognizer *pinch;
    CGFloat __previousScale;
    
    // In-play attributes
    b2Body *body;
}

+ (GameObject*)GameObjectCreate: (GameObjectType) kGameObjectType;

@property (nonatomic, readonly) GameObjectState kGameObjectState;
@property (nonatomic, readonly) GameObjectType kGameObjectType;

@property (nonatomic, readonly) CGSize defaultImageSize;
@property (nonatomic, readonly) CGSize defaultIconSize;
@property (strong, nonatomic, readonly) UIImageView* imageView;

@property b2Body *body;
@property (nonatomic, readonly) b2BodyDef bodyDef;
@property (nonatomic, readonly) b2Shape *shape;
// NOTE: Every time this property is retrieved, the retrieved object must be
//       destroyed by the caller
@property (nonatomic, readonly) b2FixtureDef fixtureDef;
@property (readonly) CGAffineTransform baseTransform;

@property (nonatomic, readonly) CGPoint center;
@property (nonatomic, readonly) CGFloat angle;
@property (nonatomic, readonly) CGFloat scale;

- (void)resetToPaletteIcon;

- (void)resizeDefault;

- (void)setUpForPlay;

- (void)setUpForBuilder;

- (void)updateView;

#pragma mark Gestures

@property (nonatomic, readonly) BOOL canTranslate;
@property (nonatomic, readonly) BOOL canRotate;
@property (nonatomic, readonly) BOOL canZoom;

- (void)translate:(UIPanGestureRecognizer *)gesture;
// MODIFIES: object model (coordinates)
// REQUIRES: game in designer mode
// EFFECTS: the user drags around the object with one finger
//          if the object is in the palette, it will be moved in the game area

- (void)rotate:(UIRotationGestureRecognizer *)gesture;
// MODIFIES: object model (rotation)
// REQUIRES: game in designer mode, object in game area
// EFFECTS: the object is rotated with a two-finger rotation gesture

- (void)zoom:(UIPinchGestureRecognizer *)gesture;
// MODIFIES: object model (size)
// REQUIRES: game in designer mode, object in game area
// EFFECTS: the object is scaled up/down with a pinch gesture

@end
