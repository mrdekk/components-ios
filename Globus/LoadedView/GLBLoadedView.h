/*--------------------------------------------------*/

#import "UIView+GLBUI.h"

/*--------------------------------------------------*/
#if defined(GLB_TARGET_IOS)
/*--------------------------------------------------*/

@interface GLBLoadedView : UIView

@property(nonatomic, strong) IBOutlet UIView* rootView;
@property(nonatomic) UIEdgeInsets rootEdgeInsets;
@property(nonatomic) CGFloat rootEdgeInsetsTop;
@property(nonatomic) CGFloat rootEdgeInsetsBottom;
@property(nonatomic) CGFloat rootEdgeInsetsLeft;
@property(nonatomic) CGFloat rootEdgeInsetsRight;

- (void)setup NS_REQUIRES_SUPER;

@end

/*--------------------------------------------------*/
#endif
/*--------------------------------------------------*/
