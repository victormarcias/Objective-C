//
//  UIView+Transition.m
//  VMLibrary
//
//  Created by Víctor Marcias  on 8/1/14.
//
//

#import "UIView+Transition.h"

@implementation UIView (Transition)

- (void)transitionToView:(UIView *)nextView
               withStyle:(TransitionStyle)transition
                duration:(NSTimeInterval)duration
                 opacity:(CGFloat)alpha
              completion:(BoolBlock)completion
{
    [self transitionToView:nextView withStyle:transition duration:duration opacity:alpha delay:0.f spacing:0.f options:0 completion:completion];
}

- (void)transitionToView:(UIView *)next
               withStyle:(TransitionStyle)transition
                duration:(NSTimeInterval)duration
                 opacity:(CGFloat)opacity
                   delay:(NSTimeInterval)delay
                 spacing:(NSUInteger)spacing
                 options:(UIViewAnimationOptions)options
              completion:(BoolBlock)completion
{
    VoidBlock animations;
    CGFloat displacement;
    CGFloat originalAlpha = self.alpha; //Original transparency
    CGFloat hiddenAlpha;
    
    CGPoint originalPosition = self.center;
    CGPoint hidePosition;       //This is where the disappearing view is going
    CGPoint hiddenPosition;     //This is where the appearing view is coming from
    
    switch (transition) {
        case TransitionSlideLeft:
        case TransitionSlideRight:
        case TransitionSwapLeft:
        case TransitionSwapRight:
        case TransitionSwapBlendLeft:
        case TransitionSwapBlendRight:
            displacement = MAX(self.frame.size.width, next.frame.size.width) + spacing;
            break;
        
        case TransitionSlideDown:
        case TransitionSlideUp:
        case TransitionSwapDown:
        case TransitionSwapUp:
        case TransitionSwapBlendDown:
        case TransitionSwapBlendUp:
            displacement = MAX(self.frame.size.height, next.frame.size.height) + spacing;
            break;

        default:
        case TransitionFade:
        case TransitionFadeBlend:
            displacement = 0.f;
            opacity = 0.f; //Fade Transition won't work with custom opacity
            break;
    }
    
    switch (transition)
    {
        case TransitionSlideLeft:
        {
            hiddenPosition = CGPointMake(self.center.x + displacement, self.center.y);
            hidePosition = CGPointMake(self.center.x - displacement, self.center.y);
            break;
        }
        case TransitionSlideRight:
        {
            hiddenPosition = CGPointMake(self.center.x - displacement, self.center.y);
            hidePosition = CGPointMake(self.center.x + displacement, self.center.y);
            break;
        }
        case TransitionSlideDown:
        {
            hiddenPosition = CGPointMake(self.center.x, self.center.y - displacement);
            hidePosition = CGPointMake(self.center.x, self.center.y + displacement);
            break;
        }
        case TransitionSlideUp:
        {
            hiddenPosition = CGPointMake(self.center.x, self.center.y + displacement);
            hidePosition = CGPointMake(self.center.x, self.center.y - displacement);
            break;
        }
            
        case TransitionSwapLeft:
        case TransitionSwapBlendLeft:
        {
            CGFloat displacementFactor = (transition == TransitionSwapLeft) ? 2.f : 1.f;
            hiddenPosition = hidePosition = CGPointMake(self.center.x - displacement * displacementFactor, self.center.y);
            break;
        }
        case TransitionSwapRight:
        case TransitionSwapBlendRight:
        {
            CGFloat displacementFactor = (transition == TransitionSwapRight) ? 2.f : 1.f;
            hiddenPosition = hidePosition = CGPointMake(self.center.x + displacement * displacementFactor, self.center.y);
            break;
        }
        case TransitionSwapDown:
        case TransitionSwapBlendDown:
        {
            CGFloat displacementFactor = (transition == TransitionSwapDown) ? 2.f : 1.f;
            hiddenPosition = hidePosition = CGPointMake(self.center.x, self.center.y + displacement * displacementFactor);
            break;
        }
        case TransitionSwapUp:
        case TransitionSwapBlendUp:
        {
            CGFloat displacementFactor = (transition == TransitionSwapUp) ? 2. : 1.f;
            hiddenPosition = hidePosition = CGPointMake(self.center.x, self.center.y - displacement * displacementFactor);
            break;
        }
            
        default:
        case TransitionFade:
        case TransitionFadeBlend:
            hiddenPosition = hidePosition = originalPosition;
            break;
    }

    //Start
    hiddenAlpha = originalAlpha * opacity;
    next.alpha = hiddenAlpha;
    next.center = hiddenPosition;
    
    //End
    animations = ^(){
        next.center = originalPosition;
        self.center = hidePosition;
        next.alpha = (transition == TransitionFade) ? hiddenAlpha : originalAlpha;
        self.alpha = hiddenAlpha;
    };
    
    //Fade Transition Note: wait until the disappearing view goes away
    if (transition == TransitionFade)
    {
        duration *= 0.5;
        BoolBlock fadeCompletion = ^(BOOL finished) {
            [UIView animateWithDuration:duration animations:^{
                next.alpha = originalAlpha;
            } completion:completion];
        };
        completion = fadeCompletion;
    }
    
    [UIView animateWithDuration:duration delay:delay options:options animations:animations completion:completion];
}

@end
