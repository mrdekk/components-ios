/*--------------------------------------------------*/

#include "GLBTargetConditionals.h"

/*--------------------------------------------------*/

#import <UIKit/UIKit.h>

/*--------------------------------------------------*/

typedef NS_OPTIONS(NSUInteger, GLBUIVerticalAlignment) {
    GLBUIVerticalAlignmentTop,
    GLBUIVerticalAlignmentCenter,
    GLBUIVerticalAlignmentBottom
};

typedef NS_OPTIONS(NSUInteger, GLBUIHorizontalAlignment) {
    GLBUIHorizontalAlignmentLeft,
    GLBUIHorizontalAlignmentCenter,
    GLBUIHorizontalAlignmentRight
};

/*--------------------------------------------------*/

typedef void(^GLBSimpleBlock)();

/*--------------------------------------------------*/
