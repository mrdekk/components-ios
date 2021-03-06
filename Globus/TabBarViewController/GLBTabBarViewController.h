/*--------------------------------------------------*/

#import "UIViewController+GLBUI.h"

/*--------------------------------------------------*/
#if defined(GLB_TARGET_IOS)
/*--------------------------------------------------*/

@class GLBTransitionController;

/*--------------------------------------------------*/

@interface GLBTabBarViewController : UITabBarController< GLBViewController >

@property(nonatomic, readonly, assign, getter=isAppeared) BOOL appeared;
@property(nonatomic, getter=isNavigationBarHidden) BOOL navigationBarHidden;
@property(nonatomic, getter=isToolbarHidden) BOOL toolbarHidden;
@property(nonatomic) BOOL hidesBarsWhenKeyboardAppears;
@property(nonatomic) BOOL hidesBarsOnSwipe;
@property(nonatomic) BOOL hidesBarsWhenVerticallyCompact;
@property(nonatomic) BOOL hidesBarsOnTap;
@property(nonatomic, strong) GLBTransitionController* transitionModal;
@property(nonatomic, strong) GLBTransitionController* transitionNavigation;

- (void)setup NS_REQUIRES_SUPER;

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated;
- (void)setToolbarHidden:(BOOL)toolbarHidden animated:(BOOL)animated;

- (void)setNeedUpdate;

@end

/*--------------------------------------------------*/
#endif
/*--------------------------------------------------*/
