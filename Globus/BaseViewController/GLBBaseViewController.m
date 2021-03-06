/*--------------------------------------------------*/

#import "GLBBaseViewController.h"
#import "GLBTransitionController.h"

/*--------------------------------------------------*/

#import "UIDevice+GLBUI.h"

/*--------------------------------------------------*/
#if defined(GLB_TARGET_IOS)
/*--------------------------------------------------*/

@interface GLBBaseViewController () < UIViewControllerTransitioningDelegate >

@property(nonatomic, getter=isAppeared) BOOL appeared;
@property(nonatomic, getter=isNeedUpdate) BOOL needUpdate;
@property(nonatomic, getter=isNeedClear) BOOL needClear;
@property(nonatomic) BOOL updating;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation GLBBaseViewController

#pragma mark - Init / Free

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString*)nib bundle:(NSBundle*)bundle {
    self = [super initWithNibName:nib bundle:bundle];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _toolbarHidden = YES;
    _hideKeyboardIfTouched = YES;
    _needUpdate = YES;
    
    self.transitioningDelegate = self;
}

- (void)dealloc {
    if(_updating == NO) {
        _updating = YES;
        if(_needClear == YES) {
            [self clear];
        }
        _updating = NO;
    }
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - Property

- (void)setView:(UIView*)view {
    super.view = view;
    if(view != nil) {
        view.clipsToBounds = YES;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if(view == nil) {
        [self viewDidUnload];
    }
    _needClear = NO;
#pragma clang diagnostic pop
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    if(_statusBarHidden != statusBarHidden) {
        _statusBarHidden = statusBarHidden;
        if(self.isViewLoaded == YES) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    if(_statusBarStyle != statusBarStyle) {
        _statusBarStyle = statusBarStyle;
        if(self.isViewLoaded == YES) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}

- (void)setStatusBarAnimation:(UIStatusBarAnimation)statusBarAnimation {
    if(_statusBarAnimation != statusBarAnimation) {
        _statusBarAnimation = statusBarAnimation;
        if(self.isViewLoaded == YES) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    [self setNavigationBarHidden:navigationBarHidden animated:NO];
}

- (void)setToolbarHidden:(BOOL)toolbarHidden {
    [self setToolbarHidden:toolbarHidden animated:NO];
}

- (void)setHidesBarsWhenKeyboardAppears:(BOOL)hidesBarsWhenKeyboardAppears {
    if(_hidesBarsWhenKeyboardAppears != hidesBarsWhenKeyboardAppears) {
        _hidesBarsWhenKeyboardAppears = hidesBarsWhenKeyboardAppears;
        
        if((self.isViewLoaded == YES) && (self.navigationController.topViewController == self)) {
            if(UIDevice.glb_systemVersion >= 8.0f) {
                self.navigationController.hidesBarsWhenKeyboardAppears = _hidesBarsWhenKeyboardAppears;
            }
        }
    }
}

- (void)setHidesBarsOnSwipe:(BOOL)hidesBarsOnSwipe {
    if(_hidesBarsOnSwipe != hidesBarsOnSwipe) {
        _hidesBarsOnSwipe = hidesBarsOnSwipe;
        
        if((self.isViewLoaded == YES) && (self.navigationController.topViewController == self)) {
            if(UIDevice.glb_systemVersion >= 8.0f) {
                self.navigationController.hidesBarsOnSwipe = _hidesBarsOnSwipe;
            }
        }
    }
}

- (void)setHidesBarsWhenVerticallyCompact:(BOOL)hidesBarsWhenVerticallyCompact {
    if(_hidesBarsWhenVerticallyCompact != hidesBarsWhenVerticallyCompact) {
        _hidesBarsWhenVerticallyCompact = hidesBarsWhenVerticallyCompact;
        
        if((self.isViewLoaded == YES) && (self.navigationController.topViewController == self)) {
            if(UIDevice.glb_systemVersion >= 8.0f) {
                self.navigationController.hidesBarsWhenVerticallyCompact = _hidesBarsWhenVerticallyCompact;
            }
        }
    }
}

- (void)setHidesBarsOnTap:(BOOL)hidesBarsOnTap {
    if(_hidesBarsOnTap != hidesBarsOnTap) {
        _hidesBarsOnTap = hidesBarsOnTap;
        
        if((self.isViewLoaded == YES) && (self.navigationController.topViewController == self)) {
            if(UIDevice.glb_systemVersion >= 8.0f) {
                self.navigationController.hidesBarsOnTap = _hidesBarsOnTap;
            }
        }
    }
}

#pragma mark - Public

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated {
    if(_navigationBarHidden != navigationBarHidden) {
        _navigationBarHidden = navigationBarHidden;
        
        if((self.isViewLoaded == YES) && (self.navigationController.topViewController == self)) {
            if(UIDevice.glb_systemVersion >= 8.0f) {
                [self.navigationController setNavigationBarHidden:_navigationBarHidden animated:animated];
            }
        }
    }
}

- (void)setToolbarHidden:(BOOL)toolbarHidden animated:(BOOL)animated {
    if(_toolbarHidden != toolbarHidden) {
        _toolbarHidden = toolbarHidden;
        
        if((self.isViewLoaded == YES) && (self.navigationController.topViewController == self)) {
            [self.navigationController setToolbarHidden:_toolbarHidden animated:animated];
        }
    }
}

- (void)setNeedUpdate {
    if(_updating == NO) {
        _updating = YES;
        if(_needClear == YES) {
            [self clear];
        }
        if(_appeared == YES) {
            [self update];
        } else {
            _needUpdate = YES;
        }
        _updating = NO;
    }
}

- (void)update {
    _needClear = YES;
}

- (void)clear {
    _needClear = NO;
}

#pragma mark - UIViewController

- (BOOL)prefersStatusBarHidden {
    return _statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return _statusBarAnimation;
}

- (void)viewDidUnload {
    if(_updating == NO) {
        _updating = YES;
        if(_needClear == YES) {
            [self clear];
        }
        _updating = NO;
    }
    _needUpdate = YES;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    
    if(_appeared == NO) {
        _appeared = YES;
        if(_needUpdate == YES) {
            _updating = YES;
            _needUpdate = NO;
            if(_needClear == YES) {
                [self clear];
            }
            [self update];
            _updating = NO;
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    if(_appeared == YES) {
        _appeared = NO;
    }
    if(_clearWhenDisapper == YES) {
        _updating = YES;
        _needUpdate = YES;
        if(_needClear == YES) {
            [self clear];
        }
        _updating = NO;
    }
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self glb_unloadViewIfPossible];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id< UIViewControllerAnimatedTransitioning >)animationControllerForPresentedController:(UIViewController*)presented presentingController:(UIViewController*)presenting sourceController:(UIViewController*)source {
    if(_transitionModal != nil) {
        _transitionModal.operation = GLBTransitionOperationPresent;
    }
    return _transitionModal;
}

- (id< UIViewControllerAnimatedTransitioning >)animationControllerForDismissedController:(UIViewController*)dismissed {
    if(_transitionModal != nil) {
        _transitionModal.operation = GLBTransitionOperationDismiss;
    }
    return _transitionModal;
}

- (id< UIViewControllerInteractiveTransitioning >)interactionControllerForPresentation:(id< UIViewControllerAnimatedTransitioning >)animator {
    if(_transitionModal != nil) {
        _transitionModal.operation = GLBTransitionOperationPresent;
    }
    return _transitionModal;
}

- (id< UIViewControllerInteractiveTransitioning >)interactionControllerForDismissal:(id< UIViewControllerAnimatedTransitioning >)animator {
    if(_transitionModal != nil) {
        _transitionModal.operation = GLBTransitionOperationDismiss;
    }
    return _transitionModal;
}

@end

/*--------------------------------------------------*/
#endif
/*--------------------------------------------------*/
