/*--------------------------------------------------*/

#import "NSObject+GLBNS.h"

/*--------------------------------------------------*/

@interface NSError (GLB_NS) < GLBObjectDebugProtocol >

- (BOOL)glb_isURLError;
- (BOOL)glb_URLErrorConnectedToInternet;
- (BOOL)glb_URLErrorCancelled;
- (BOOL)glb_URLErrorTimedOut;

@end

/*--------------------------------------------------*/
