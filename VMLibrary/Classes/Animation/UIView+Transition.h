//
//  UIView+Transition.h
//  VMLibrary
//
//  Created by Víctor Marcias on 8/1/14.
//
//  -----------------------------------------------------------
//  Basic animation transitions between views
//

#import <UIKit/UIKit.h>

typedef void (^VoidBlock)();
typedef void (^BoolBlock)(BOOL boolParam);

typedef enum {
    //Normal Transitions: one view goes away and the other comes sliding in the other way
    TransitionSlideUp,
    TransitionSlideDown,
    TransitionSlideLeft,
    TransitionSlideRight,
    
    //Swap Transitions: the other view slides in from the same direction the original slides out
    TransitionSwapUp,
    TransitionSwapDown,
    TransitionSwapLeft,
    TransitionSwapRight,
    
    //Swap+Blend: same as Swap Transitions but simultaneously
    TransitionSwapBlendUp,
    TransitionSwapBlendDown,
    TransitionSwapBlendLeft,
    TransitionSwapBlendRight,
    
    //Fade: one disappears, the other appears (opacity parameter is ignored)
    TransitionFade,
    TransitionFadeBlend
    
} TransitionStyle;

@interface UIView (Transition)

- (void)transitionToView:(UIView *)nextView
               withStyle:(TransitionStyle)transition
                duration:(NSTimeInterval)duration
                 opacity:(CGFloat)alpha
              completion:(BoolBlock)completion;

- (void)transitionToView:(UIView *)nextView
               withStyle:(TransitionStyle)transition
                duration:(NSTimeInterval)duration
                 opacity:(CGFloat)alpha
                   delay:(NSTimeInterval)delay
                 spacing:(NSUInteger)spacing
                 options:(UIViewAnimationOptions)options
              completion:(BoolBlock)completion;

@end
