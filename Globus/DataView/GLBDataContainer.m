/*--------------------------------------------------*/

#import "GLBDataContainer+Private.h"

/*--------------------------------------------------*/
#if defined(GLB_TARGET_IOS)
/*--------------------------------------------------*/

#import "NSArray+GLBNS.h"

/*--------------------------------------------------*/

@implementation GLBDataContainer

#pragma mark - Synthesize

@synthesize view = _view;
@synthesize parent = _parent;
@synthesize frame = _frame;
@synthesize hidden = _hidden;
@synthesize allowAutoAlign = _allowAutoAlign;
@synthesize alignInsets = _alignInsets;
@synthesize alignPosition = _alignPosition;
@synthesize alignThreshold = _alignThreshold;

#pragma mark - Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _alignPosition = GLBDataContainerAlignNone;
    _alignThreshold = UIOffsetMake(20.0f, 20.0f);
}

- (void)dealloc {
}

#pragma mark - Property

- (void)setView:(GLBDataView*)view {
    if(_view != view) {
        [self _willChangeView];
        _view = view;
        [self _didChangeView];
    }
}

- (void)setParent:(GLBDataContainer*)parent {
    if(_parent != parent) {
        [self _willChangeParent];
        _parent = parent;
        [self _didChangeParent];
    }
}

- (CGRect)frame {
    [_view validateLayoutIfNeed];
    return _frame;
}

- (void)setHidden:(BOOL)hidden {
    if(_hidden != hidden) {
        _hidden = hidden;
        [_view setNeedValidateLayout];
    }
}

- (BOOL)isHiddenInHierarchy {
    if(_hidden == YES) {
        return YES;
    }
    return _parent.hiddenInHierarchy;
}

#pragma mark - Property private

- (void)_willChangeView {
}

- (void)_didChangeView {
}

- (void)_willChangeParent {
}

- (void)_didChangeParent {
    if(_parent != nil) {
        self.view = _parent.view;
    }
}

- (void)_willBeginDragging {
}

- (void)_didScrollDragging:(BOOL)dragging decelerating:(BOOL)decelerating {
}

- (void)_willEndDraggingWithVelocity:(CGPoint)velocity contentOffset:(inout CGPoint*)contentOffset contentSize:(CGSize)contentSize visibleSize:(CGSize)visibleSize {
    if(_allowAutoAlign == YES) {
        *contentOffset = [self _alignWithVelocity:velocity contentOffset:*contentOffset contentSize:contentSize visibleSize:visibleSize];
    }
}

- (void)_didEndDraggingWillDecelerate:(BOOL __unused)decelerate {
}

- (void)_willBeginDecelerating {
}

- (void)_didEndDecelerating {
}

- (void)_didEndScrollingAnimation {
}

- (void)_beginUpdateAnimated:(BOOL __unused)animated {
}

- (void)_endUpdateAnimated:(BOOL __unused)animated {
    if(_allowAutoAlign == YES) {
        [self align];
    }
}

- (CGPoint)_alignPointWithContentOffset:(CGPoint)contentOffset contentSize:(CGSize)contentSize visibleSize:(CGSize)visibleSize {
    CGPoint alignPoint = CGPointZero;
    CGRect visibleRect = CGRectMake(_alignInsets.left, _alignInsets.top, visibleSize.width - (_alignInsets.left + _alignInsets.right), visibleSize.height - (_alignInsets.top + _alignInsets.bottom));
    if((_alignPosition & GLBDataContainerAlignLeft) != 0) {
        alignPoint.x = contentOffset.x + visibleRect.origin.x;
    } else if((_alignPosition & GLBDataContainerAlignCenteredHorizontally) != 0) {
        alignPoint.x = contentOffset.x + (visibleRect.origin.x + (visibleRect.size.width * 0.5f));
    } else if((_alignPosition & GLBDataContainerAlignRight) != 0) {
        alignPoint.x = contentOffset.x + (visibleRect.origin.x + visibleRect.size.width);
    } else {
        alignPoint.x = contentOffset.x;
    }
    if((_alignPosition & GLBDataContainerAlignTop) != 0) {
        alignPoint.y = contentOffset.y + visibleRect.origin.y;
    } else if((_alignPosition & GLBDataContainerAlignCenteredVertically) != 0) {
        alignPoint.y = contentOffset.y + (visibleRect.origin.y + (visibleRect.size.height * 0.5f));
    } else if((_alignPosition & GLBDataContainerAlignBottom) != 0) {
        alignPoint.y = contentOffset.y + (visibleRect.origin.y + visibleRect.size.height);
    } else {
        alignPoint.y = contentOffset.y;
    }
    return alignPoint;
}

- (CGPoint)_alignWithVelocity:(CGPoint __unused)velocity contentOffset:(CGPoint)contentOffset contentSize:(CGSize __unused)contentSize visibleSize:(CGSize __unused)visibleSize {
    return contentOffset;
}

- (CGRect)_validateLayoutForAvailableFrame:(CGRect __unused)frame {
    return CGRectNull;
}

- (void)_willLayoutForBounds:(CGRect __unused)bounds {
}

- (void)_didLayoutForBounds:(CGRect __unused)bounds {
}

- (void)_beginMovingItem:(GLBDataItem*)item location:(CGPoint)location {
}

- (void)_movingItem:(GLBDataItem*)item location:(CGPoint)location delta:(CGPoint)delta allowsSorting:(BOOL)allowsSorting {
}

- (void)_endMovingItem:(GLBDataItem*)item location:(CGPoint)location {
}

#pragma mark - Public

- (NSArray*)allItems {
    return @[];
}

- (void)setNeedResize {
}

- (void)setNeedReload {
}

- (GLBDataItem*)itemForPoint:(CGPoint __unused)point {
    return nil;
}

- (GLBDataItem*)itemForData:(id __unused)data {
    return nil;
}

- (GLBDataCell*)cellForData:(id)data {
    GLBDataItem* item = [self itemForData:data];
    if(item != nil) {
        return item.cell;
    }
    return nil;
}

- (BOOL)containsActionForKey:(id)key {
    return [_view containsActionForKey:key];
}

- (BOOL)containsActionForIdentifier:(id)identifier forKey:(id)key {
    return [_view containsActionForIdentifier:identifier forKey:key];
}

- (void)performActionForKey:(id)key withArguments:(NSArray*)arguments {
    [_view performActionForKey:key withArguments:[@[ self ] glb_unionWithArray:arguments]];
}

- (void)performActionForIdentifier:(id)identifier forKey:(id)key withArguments:(NSArray*)arguments {
    [_view performActionForIdentifier:identifier forKey:key withArguments:[@[ self ] glb_unionWithArray:arguments]];
}

- (CGPoint)alignPoint {
    return [self _alignPointWithContentOffset:_view.contentOffset contentSize:_view.contentSize visibleSize:_view.glb_boundsSize];
}

- (void)align {
    if((_view.dragging == NO) && (_view.decelerating == NO)) {
        [_view setContentOffset:[self _alignWithVelocity:CGPointZero contentOffset:_view.contentOffset contentSize:_view.contentSize visibleSize:_view.glb_boundsSize] animated:YES];
    }
}

#pragma mark - GLBSearchBarDelegate

- (void)searchBarBeginSearch:(GLBSearchBar*)searchBar {
}

- (void)searchBarEndSearch:(GLBSearchBar*)searchBar {
}

- (void)searchBarBeginEditing:(GLBSearchBar*)searchBar {
}

- (void)searchBar:(GLBSearchBar*)searchBar textChanged:(NSString*)textChanged {
}

- (void)searchBarEndEditing:(GLBSearchBar*)searchBar {
}

- (void)searchBarPressedClear:(GLBSearchBar*)searchBar {
}

- (void)searchBarPressedReturn:(GLBSearchBar*)searchBar {
}

- (void)searchBarPressedCancel:(GLBSearchBar*)searchBar {
}

@end

/*--------------------------------------------------*/
#endif
/*--------------------------------------------------*/
