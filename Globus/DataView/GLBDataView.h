/*--------------------------------------------------*/

#import "UIScrollView+GLBUI.h"
#import "GLBDataViewTypes.h"
#import "GLBPageControl.h"

/*--------------------------------------------------*/
#if defined(GLB_TARGET_IOS)
/*--------------------------------------------------*/

@class GLBDataContainer;
@class GLBDataItem;
@class GLBDataCell;
@class GLBDataRefreshView;

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, GLBDataViewSearchBarStyle) {
    GLBDataViewSearchBarStyleStatic,
    GLBDataViewSearchBarStyleInside,
    GLBDataViewSearchBarStyleOverlay
};

/*--------------------------------------------------*/

@protocol GLBDataRefreshView;

/*--------------------------------------------------*/

@interface GLBDataContentView : UIView
@end

/*--------------------------------------------------*/

@interface GLBDataView : UIScrollView < UIGestureRecognizerDelegate, GLBScrollViewExtension, GLBSearchBarDelegate >

@property(nonatomic, readonly, strong) GLBDataContentView* contentView;

@property(nonatomic) IBInspectable CGFloat velocity;
@property(nonatomic) IBInspectable CGFloat velocityMin;
@property(nonatomic) IBInspectable CGFloat velocityMax;

@property(nonatomic) IBInspectable BOOL allowsSelection;
@property(nonatomic) IBInspectable BOOL allowsOnceSelection;
@property(nonatomic) IBInspectable BOOL allowsMultipleSelection;
@property(nonatomic) IBInspectable BOOL allowsEditing;
@property(nonatomic) IBInspectable BOOL allowsMultipleEditing;
@property(nonatomic) IBInspectable BOOL allowsMoving;
@property(nonatomic) IBInspectable BOOL allowsMultipleMoving;
@property(nonatomic) IBInspectable BOOL bouncesTop;
@property(nonatomic) IBInspectable BOOL bouncesLeft;
@property(nonatomic) IBInspectable BOOL bouncesRight;
@property(nonatomic) IBInspectable BOOL bouncesBottom;

@property(nonatomic) UIEdgeInsets edgeInset;
@property(nonatomic) CGFloat edgeInsetTop;
@property(nonatomic) CGFloat edgeInsetRight;
@property(nonatomic) CGFloat edgeInsetBottom;
@property(nonatomic) CGFloat edgeInsetLeft;

@property(nonatomic, strong) __kindof GLBDataContainer* container;
@property(nonatomic) UIEdgeInsets containerInset;
@property(nonatomic) CGFloat containerInsetTop;
@property(nonatomic) CGFloat containerInsetRight;
@property(nonatomic) CGFloat containerInsetBottom;
@property(nonatomic) CGFloat containerInsetLeft;
@property(nonatomic, readonly, strong) NSArray< __kindof GLBDataItem* >* visibleItems;
@property(nonatomic, readonly, strong) NSArray< __kindof GLBDataCell* >* visibleCells;
@property(nonatomic, readonly, strong) NSArray< __kindof GLBDataItem* >* selectedItems;
@property(nonatomic, readonly, strong) NSArray< __kindof GLBDataCell* >* selectedCells;
@property(nonatomic, readonly, strong) NSArray< __kindof GLBDataItem* >* highlightedItems;
@property(nonatomic, readonly, strong) NSArray< __kindof GLBDataCell* >* highlightedCells;
@property(nonatomic, readonly, strong) NSArray< __kindof GLBDataItem* >* editingItems;
@property(nonatomic, readonly, strong) NSArray< __kindof GLBDataCell* >* editingCells;
@property(nonatomic, readonly, strong) __kindof GLBDataItem* movingItem;
@property(nonatomic, readonly, strong) __kindof GLBDataCell* movingCell;
@property(nonatomic, readonly, assign, getter=isAnimating) BOOL animating;
@property(nonatomic, readonly, assign, getter=isUpdating) BOOL updating;

@property(nonatomic, weak) IBOutlet __kindof GLBPageControl* pageControl;

@property(nonatomic) IBInspectable BOOL searchBarIteractionEnabled;
@property(nonatomic, getter=isShowedSearchBar) IBInspectable BOOL showedSearchBar;
@property(nonatomic) IBInspectable GLBDataViewSearchBarStyle searchBarStyle;
@property(nonatomic, strong) IBOutlet __kindof GLBSearchBar* searchBar;
@property(nonatomic, readonly, assign) CGFloat searchBarInset;

@property(nonatomic) IBInspectable BOOL topRefreshIteractionEnabled;
@property(nonatomic) IBInspectable BOOL topRefreshBelowDataView;
@property(nonatomic, strong) IBOutlet __kindof GLBDataRefreshView* topRefreshView;
@property(nonatomic) IBInspectable BOOL bottomRefreshIteractionEnabled;
@property(nonatomic) IBInspectable BOOL bottomRefreshBelowDataView;
@property(nonatomic, strong) IBOutlet __kindof GLBDataRefreshView* bottomRefreshView;
@property(nonatomic) IBInspectable BOOL leftRefreshIteractionEnabled;
@property(nonatomic) IBInspectable BOOL leftRefreshBelowDataView;
@property(nonatomic, strong) IBOutlet __kindof GLBDataRefreshView* leftRefreshView;
@property(nonatomic) IBInspectable BOOL rightRefreshIteractionEnabled;
@property(nonatomic) IBInspectable BOOL rightRefreshBelowDataView;
@property(nonatomic, strong) IBOutlet __kindof GLBDataRefreshView* rightRefreshView;
@property(nonatomic, readonly, assign) UIEdgeInsets refreshViewInset;

- (void)setup NS_REQUIRES_SUPER;

- (void)registerIdentifier:(NSString*)identifier withViewClass:(Class)viewClass;
- (void)unregisterIdentifier:(NSString*)identifier;
- (void)unregisterAllIdentifiers;

- (void)registerActionWithTarget:(id)target action:(SEL)action forKey:(id)key;
- (void)registerActionWithTarget:(id)target action:(SEL)action forIdentifier:(id)identifier forKey:(id)key;
- (void)unregisterActionWithTarget:(id)target forKey:(id)key;
- (void)unregisterActionWithTarget:(id)target forIdentifier:(id)identifier forKey:(id)key;
- (void)unregisterActionsWithTarget:(id)target;
- (void)unregisterAllActions;

- (BOOL)containsActionForKey:(id)key;
- (BOOL)containsActionForIdentifier:(id)identifier forKey:(id)key;

- (void)performActionForKey:(id)key withArguments:(NSArray*)arguments;
- (void)performActionForIdentifier:(id)identifier forKey:(id)key withArguments:(NSArray*)arguments;

- (Class)cellClassWithItem:(GLBDataItem*)item;

- (void)dequeueCellWithItem:(GLBDataItem*)item;
- (void)enqueueCellWithItem:(GLBDataItem*)item;

- (__kindof GLBDataItem*)itemForPoint:(CGPoint)point;
- (__kindof GLBDataItem*)itemForData:(id)data;
- (__kindof GLBDataCell*)cellForData:(id)data;

- (BOOL)isSelectedItem:(GLBDataItem*)item;
- (BOOL)shouldSelectItem:(GLBDataItem*)item;
- (BOOL)shouldDeselectItem:(GLBDataItem*)item;
- (void)selectItem:(GLBDataItem*)item animated:(BOOL)animated;
- (void)deselectItem:(GLBDataItem*)item animated:(BOOL)animated;
- (void)deselectAllItemsAnimated:(BOOL)animated;

- (BOOL)isHighlightedItem:(GLBDataItem*)item;
- (BOOL)shouldHighlightItem:(GLBDataItem*)item;
- (BOOL)shouldUnhighlightItem:(GLBDataItem*)item;
- (void)highlightItem:(GLBDataItem*)item animated:(BOOL)animated;
- (void)unhighlightItem:(GLBDataItem*)item animated:(BOOL)animated;
- (void)unhighlightAllItemsAnimated:(BOOL)animated;

- (BOOL)isEditingItem:(GLBDataItem*)item;
- (BOOL)shouldBeganEditItem:(GLBDataItem*)item;
- (BOOL)shouldEndedEditItem:(GLBDataItem*)item;
- (void)beganEditItem:(GLBDataItem*)item animated:(BOOL)animated;
- (void)endedEditItem:(GLBDataItem*)item animated:(BOOL)animated;
- (void)endedEditAllItemsAnimated:(BOOL)animated;

- (BOOL)isMovingItem:(GLBDataItem*)item;
- (BOOL)shouldBeganMoveItem:(GLBDataItem*)item;
- (BOOL)shouldEndedMoveItem:(GLBDataItem*)item;
- (void)beganMoveItem:(GLBDataItem*)item animated:(BOOL)animated;
- (void)endedMoveItemAnimated:(BOOL)animated;

- (void)batchUpdate:(GLBSimpleBlock)update;
- (void)batchUpdate:(GLBSimpleBlock)update complete:(GLBSimpleBlock)complete;
- (void)batchDuration:(NSTimeInterval)duration update:(GLBSimpleBlock)update;
- (void)batchDuration:(NSTimeInterval)duration update:(GLBSimpleBlock)update complete:(GLBSimpleBlock)complete;

- (void)setNeedValidateLayout;
- (void)validateLayoutIfNeed;

- (void)setNeedLayoutForVisible;
- (void)layoutForVisibleIfNeed;

- (void)animateContentOffset:(CGPoint)contentOffset
          withTimingFunction:(CAMediaTimingFunction*)timingFunction;

- (void)animateContentOffset:(CGPoint)contentOffset
          withTimingFunction:(CAMediaTimingFunction*)timingFunction
                    duration:(CFTimeInterval)duration;

- (void)stopAnimateContentOffset;

- (void)scrollToItem:(GLBDataItem*)item scrollPosition:(GLBDataViewPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToRect:(CGRect)rect scrollPosition:(GLBDataViewPosition)scrollPosition animated:(BOOL)animated;

- (void)showSearchBarAnimated:(BOOL)animated complete:(GLBSimpleBlock)complete;
- (void)hideSearchBarAnimated:(BOOL)animated complete:(GLBSimpleBlock)complete;

- (void)showTopRefreshAnimated:(BOOL)animated complete:(GLBSimpleBlock)complete;
- (void)hideTopRefreshAnimated:(BOOL)animated complete:(GLBSimpleBlock)complete;
- (void)showBottomRefreshAnimated:(BOOL)animated complete:(GLBSimpleBlock)complete;
- (void)hideBottomRefreshAnimated:(BOOL)animated complete:(GLBSimpleBlock)complete;
- (void)showLeftRefreshAnimated:(BOOL)animated complete:(GLBSimpleBlock)complete;
- (void)hideLeftRefreshAnimated:(BOOL)animated complete:(GLBSimpleBlock)complete;
- (void)showRightRefreshAnimated:(BOOL)animated complete:(GLBSimpleBlock)complete;
- (void)hideRightRefreshAnimated:(BOOL)animated complete:(GLBSimpleBlock)complete;

@end

/*--------------------------------------------------*/

extern NSString* GLBDataViewSelectItem;
extern NSString* GLBDataViewDeselectItem;

/*--------------------------------------------------*/

extern NSString* GLBDataViewMovingBegin;
extern NSString* GLBDataViewMovingEnd;

/*--------------------------------------------------*/

extern NSString* GLBDataViewSearchBegin;
extern NSString* GLBDataViewSearchEnd;
extern NSString* GLBDataViewSearchBeginEditing;
extern NSString* GLBDataViewSearchTextChanged;
extern NSString* GLBDataViewSearchEndEditing;
extern NSString* GLBDataViewSearchPressedClear;
extern NSString* GLBDataViewSearchPressedReturn;
extern NSString* GLBDataViewSearchPressedCancel;

/*--------------------------------------------------*/

extern NSString* GLBDataViewTopRefreshTriggered;
extern NSString* GLBDataViewBottomRefreshTriggered;
extern NSString* GLBDataViewLeftRefreshTriggered;
extern NSString* GLBDataViewRightRefreshTriggered;

/*--------------------------------------------------*/

extern NSString* GLBDataViewAnimateRestore;
extern NSString* GLBDataViewAnimateInsert;
extern NSString* GLBDataViewAnimateDelete;
extern NSString* GLBDataViewAnimateReplaceOut;
extern NSString* GLBDataViewAnimateReplaceIn;

/*--------------------------------------------------*/
#endif
/*--------------------------------------------------*/
