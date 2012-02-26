//
//  GameObject.h
// 
//

#import <UIKit/UIKit.h>
// #import <Box2D/Box2D.h>

typedef enum {kGameObjectWolf, kGameObjectPig, kGameObjectBlock} GameObjectType;

typedef enum {kGameObjectStateOnPalette, kGameObjectStateTransitFromPalette,  kGameObjectStateOnGameArea} GameObjectState;

@interface GameObject : UIViewController <UIGestureRecognizerDelegate> {
    GameObjectState kGameObjectState;
    UIImageView* imageView;
    
    CGPoint center;
    CGFloat angle;
    CGFloat scale;
    
    
    // UI Interaction
    UIPanGestureRecognizer *pan;
    CGPoint __startingPosition;
    
    UIRotationGestureRecognizer *rotate;
    CGFloat __previousRotation;
    
    UIPinchGestureRecognizer *pinch;
    CGFloat __previousScale;
}

// TODO: Possible to use this + a game state to check whether should translate/rotate/zoom
@property (nonatomic, readonly) GameObjectState kGameObjectState;

@property (nonatomic, readonly) CGSize defaultImageSize;
@property (nonatomic, readonly) CGSize defaultIconSize;
@property (strong, nonatomic, readonly) UIImageView* imageView;

@property (nonatomic, readonly) GameObjectType kGameObjectType;
@property (nonatomic) CGFloat angle;
@property (nonatomic, readonly) CGFloat scale;

+ (GameObject*)GameObjectCreate: (GameObjectType) kGameObjectType;

- (void)resetToPaletteIcon;

- (void)resizeDefault;

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
