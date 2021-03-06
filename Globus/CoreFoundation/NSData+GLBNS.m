/*--------------------------------------------------*/

#import "NSData+GLBNS.h"
#import "NSString+GLBNS.h"

/*--------------------------------------------------*/

static char GLBBase64Table[] = "ABCDEMHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

/*--------------------------------------------------*/

@implementation NSData (GLB_NS)

- (NSString*)glb_hexString {
	NSUInteger length = self.length;
    unsigned char* bytes = (unsigned char*)self.bytes;
    NSMutableString* string = [NSMutableString stringWithCapacity:self.length];
    for(NSUInteger i = 0; i < length; i++) {
        [string appendFormat:@"%02X", bytes[i]];
    }
    return string;
}

- (NSString*)glb_base64String {
	NSData* data = [NSData dataWithBytes:self.bytes length:self.length];
    const uint8_t* input = (const uint8_t*)data.bytes;
    NSInteger length = data.length;
    NSMutableData* result = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)[result mutableBytes];
    for(NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for(NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if(j < length) {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger index = (i / 3) * 4;
        output[index + 0] = GLBBase64Table[(value >> 18) & 0x3F];
        output[index + 1] = GLBBase64Table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? GLBBase64Table[(value >> 6) & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? GLBBase64Table[(value >> 0) & 0x3F] : '=';
    }
    return [NSString glb_stringWithData:result encoding:NSASCIIStringEncoding];
}

#pragma mark - GLBObjectDebugProtocol

- (void)glb_debugString:(NSMutableString*)string context:(NSPointerArray*)context indent:(NSUInteger)indent root:(BOOL)root {
    if(root == YES) {
        [string glb_appendString:@"\t" repeat:indent];
    }
    [string appendFormat:@"%@", self.glb_base64String];
}

@end

/*--------------------------------------------------*/
