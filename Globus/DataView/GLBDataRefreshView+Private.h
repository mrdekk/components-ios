/*--------------------------------------------------*/

#import "GLBDataRefreshView.h"
#import "GLBDataView+Private.h"

/*--------------------------------------------------*/
#if defined(GLB_TARGET_IOS)
/*--------------------------------------------------*/

@interface GLBDataRefreshView () {
@protected
    GLBDataRefreshViewType _type;
    __weak GLBDataView* _view;
    __weak NSLayoutConstraint* _constraintOffset;
    __weak NSLayoutConstraint* _constraintSize;
    GLBDataRefreshViewState _state;
    BOOL _triggeredOnRelease;
    CGFloat _size;
    CGFloat _threshold;
}

@property(nonatomic, weak) GLBDataView* view;
@property(nonatomic, weak) NSLayoutConstraint* constraintOffset;
@property(nonatomic, weak) NSLayoutConstraint* constraintSize;
@property(nonatomic) GLBDataRefreshViewState state;

- (void)_showAnimated:(BOOL)animated velocity:(CGFloat)velocity complete:(GLBSimpleBlock)complete;
- (void)_hideAnimated:(BOOL)animated velocity:(CGFloat)velocity complete:(GLBSimpleBlock)complete;

@end

/*--------------------------------------------------*/
#endif
/*--------------------------------------------------*/
