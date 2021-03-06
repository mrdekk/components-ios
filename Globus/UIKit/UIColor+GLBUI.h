/*--------------------------------------------------*/

#import "GLBUI.h"

/*--------------------------------------------------*/

@interface UIColor (GLB_UI)

+ (UIColor* _Nullable)glb_colorWithString:(NSString* _Nonnull)string;
+ (CGFloat)glb_colorComponentFromString:(NSString* _Nonnull)string start:(NSUInteger)start length:(NSUInteger)length;

- (NSString* _Nullable)glb_stringValue;

- (UIColor* _Nullable)glb_multiplyColor:(UIColor* _Nonnull)color percent:(CGFloat)percent;
- (UIColor* _Nullable)glb_multiplyBrightness:(CGFloat)brightness;

@end

/*--------------------------------------------------*/
