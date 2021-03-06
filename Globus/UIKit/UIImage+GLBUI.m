/*--------------------------------------------------*/

#import "UIImage+GLBUI.h"
#import "GLBRect.h"

/*--------------------------------------------------*/
#if defined(GLB_TARGET_IOS)
/*--------------------------------------------------*/

#import <Accelerate/Accelerate.h>

/*--------------------------------------------------*/

@implementation UIImage (GLB_UI)

+ (UIImage*)glb_imageNamed:(NSString*)name capInsets:(UIEdgeInsets)capInsets {
    UIImage* result = [self imageNamed:name];
    if(result != nil) {
        result = [result resizableImageWithCapInsets:capInsets];
    }
    return result;
}

+ (UIImage*)glb_imageWithColor:(UIColor*)color size:(CGSize)size {
    return [self glb_imageWithColor:color size:size cornerRadius:0.0f];
}

+ (UIImage*)glb_imageWithColor:(UIColor*)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(context != NULL) {
        CGContextSetFillColorWithColor(context, [color CGColor]);
        if(cornerRadius > FLT_EPSILON) {
            CGPathRef path = CGPathCreateWithRoundedRect(CGRectMake(0.0f, 0.0f, size.width, size.height), cornerRadius, cornerRadius, NULL);
            CGContextAddPath(context, path);
            CGContextDrawPath(context, kCGPathFill);
            CGPathRelease(path);
        } else {
            CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
        }
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

- (UIImage*)glb_unrotate {
    UIImage* result = nil;
    CGImageRef imageRef = self.CGImage;
    if(imageRef != NULL) {
        CGSize originalSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
        CGSize finalSize = CGSizeZero;
        CGAffineTransform transform = CGAffineTransformIdentity;
        switch(self.imageOrientation) {
            case UIImageOrientationUp: {
                transform = CGAffineTransformIdentity;
                finalSize = originalSize;
                break;
            }
            case UIImageOrientationUpMirrored: {
                transform = CGAffineTransformMakeTranslation(originalSize.width, 0.0);
                transform = CGAffineTransformScale(transform, -1.0, 1.0);
                finalSize = originalSize;
                break;
            }
            case UIImageOrientationDown: {
                transform = CGAffineTransformMakeTranslation(originalSize.width, originalSize.height);
                transform = CGAffineTransformRotate(transform, M_PI);
                finalSize = originalSize;
                break;
            }
            case UIImageOrientationDownMirrored: {
                transform = CGAffineTransformMakeTranslation(0.0, originalSize.height);
                transform = CGAffineTransformScale(transform, 1.0, -1.0);
                finalSize = originalSize;
                break;
            }
            case UIImageOrientationLeftMirrored: {
                transform = CGAffineTransformMakeTranslation(originalSize.height, originalSize.width);
                transform = CGAffineTransformScale(transform, -1.0, 1.0);
                transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
                finalSize = CGSizeMake(originalSize.height, originalSize.width);
                break;
            }
            case UIImageOrientationLeft: {
                transform = CGAffineTransformMakeTranslation(0.0, originalSize.width);
                transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
                finalSize = CGSizeMake(originalSize.height, originalSize.width);
                break;
            }
            case UIImageOrientationRightMirrored: {
                transform = CGAffineTransformMakeScale(-1.0, 1.0);
                transform = CGAffineTransformRotate(transform, M_PI / 2.0);
                finalSize = CGSizeMake(originalSize.height, originalSize.width);
                break;
            }
            case UIImageOrientationRight: {
                transform = CGAffineTransformMakeTranslation(originalSize.height, 0.0);
                transform = CGAffineTransformRotate(transform, M_PI / 2.0);
                finalSize = CGSizeMake(originalSize.height, originalSize.width);
                break;
            }
            default:
                break;
        }
        if((finalSize.width > FLT_EPSILON) && (finalSize.height > FLT_EPSILON)) {
            UIGraphicsBeginImageContextWithOptions(finalSize, NO, UIScreen.mainScreen.scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            if(context != NULL) {
                switch(self.imageOrientation) {
                    case UIImageOrientationRight:
                    case UIImageOrientationLeft:
                        CGContextScaleCTM(context, -1.0f, 1.0f);
                        CGContextTranslateCTM(context, -originalSize.height, 0.0f);
                        break;
                    default:
                        CGContextScaleCTM(context, 1.0f, -1.0f);
                        CGContextTranslateCTM(context, 0.0f, -originalSize.height);
                        break;
                }
                CGContextConcatCTM(context, transform);
                CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0.0f, 0.0f, originalSize.width, originalSize.height), imageRef);
                result = UIGraphicsGetImageFromCurrentImageContext();
            }
            UIGraphicsEndImageContext();
        }
    }
    return result;
}

- (UIImage*)glb_scaleToSize:(CGSize)size {
    UIImage* result = nil;
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    if(colourSpace != NULL) {
        CGRect drawRect = GLBRectAspectFitFromBoundsAndSize(CGRectMake(0.0f, 0.0f, size.width, size.height), self.size);
        drawRect.size.width = floorf(drawRect.size.width);
        drawRect.size.height = floorf(drawRect.size.height);
        
        CGContextRef context = CGBitmapContextCreate(NULL, drawRect.size.width, drawRect.size.height, 8, drawRect.size.width * 4, colourSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
        if(context != NULL) {
            CGContextClearRect(context, CGRectMake(0.0f, 0.0f, drawRect.size.width, drawRect.size.height));
            CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, drawRect.size.width, drawRect.size.height), self.CGImage);
            
            CGImageRef image = CGBitmapContextCreateImage(context);
            if(image != NULL) {
                result = [UIImage imageWithCGImage:image scale:self.scale orientation:self.imageOrientation];
                CGImageRelease(image);
            }
            CGContextRelease(context);
        }
        CGColorSpaceRelease(colourSpace);
    }
    return result;
}

- (UIImage*)glb_rotateToAngleInRadians:(CGFloat)angleInRadians {
    UIImage* result = nil;
    CGSize size = self.size;
    if((size.width > 0.0f) && (size.height > 0.0f)) {
        UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if(context != NULL) {
            CGContextTranslateCTM(context, 0.5f * size.width, 0.5f * size.height);
            CGContextRotateCTM(context, angleInRadians);
            CGContextTranslateCTM(context, -0.5f * size.width, -0.5f * size.height);
            [self drawAtPoint:CGPointZero];
            result = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
    }
    return result;
}

- (UIImage*)glb_grayscale {
    UIImage* result = nil;
    CGSize size = self.size;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    if(colorSpace != NULL) {
        CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
        if(context != NULL) {
            CGContextDrawImage(context, rect, [self CGImage]);
            CGImageRef grayscale = CGBitmapContextCreateImage(context);
            if(context != NULL) {
                result = [UIImage imageWithCGImage:grayscale];
                CGImageRelease(grayscale);
            }
            CGContextRelease(context);
        }
        CGColorSpaceRelease(colorSpace);
    }
    return result;
}

- (UIImage*)glb_blackAndWhite {
    UIImage* result = nil;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    if(colorSpace != NULL) {
        CGContextRef context = CGBitmapContextCreate(nil, self.size.width, self.size.height, 8, self.size.width, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
        if(colorSpace != NULL) {
            CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
            CGContextSetShouldAntialias(context, NO);
            CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            CGImageRef bwImage = CGBitmapContextCreateImage(context);
            if(bwImage != NULL) {
                result = [UIImage imageWithCGImage:bwImage];
                CGImageRelease(bwImage);
            }
            CGContextRelease(context);
        }
        CGColorSpaceRelease(colorSpace);
    }
    return result;
}

- (UIImage*)glb_invertColors {
    UIImage* result = nil;
    UIGraphicsBeginImageContextWithOptions(self.size, NO, UIScreen.mainScreen.scale);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeCopy);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), UIColor.whiteColor.CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, self.size.width, self.size.height));
    result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (UIImage*)glb_blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor*)tintColor {
    UIImage* image = nil;
    CGSize size = self.size;
    CGFloat scale = self.scale;
    if(floorf(size.width) * floorf(size.height) > FLT_EPSILON) {
        CGImageRef imageRef = self.CGImage;
        uint32_t boxSize = (uint32_t)(radius * scale);
        if(boxSize % 2 == 0) {
            boxSize++;
        }
        vImage_Buffer buffer1;
        buffer1.width = CGImageGetWidth(imageRef);
        buffer1.height = CGImageGetHeight(imageRef);
        buffer1.rowBytes = CGImageGetBytesPerRow(imageRef);
        size_t bytes = buffer1.rowBytes * buffer1.height;
        buffer1.data = malloc(bytes);
        if(buffer1.data != NULL) {
            vImage_Buffer buffer2;
            buffer2.width = buffer1.width;
            buffer2.height = buffer1.height;
            buffer2.rowBytes = buffer1.rowBytes;
            buffer2.data = malloc(bytes);
            if(buffer2.data != nil) {
                size_t tempBufferSize = (size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend + kvImageGetTempBufferSize);
                if(tempBufferSize > 0) {
                    void* tempBuffer = malloc(tempBufferSize);
                    if(tempBuffer != nil) {
                        CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
                        if(dataSource != NULL) {
                            memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
                            CFRelease(dataSource);
                        }
                        for(NSUInteger i = 0; i < iterations; i++) {
                            if(vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend) == kvImageNoError) {
                                void* temp = buffer1.data;
                                buffer1.data = buffer2.data;
                                buffer2.data = temp;
                            }
                        }
                        free(tempBuffer);
                        CGContextRef context = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height, 8, buffer1.rowBytes, CGImageGetColorSpace(imageRef), CGImageGetBitmapInfo(imageRef));
                        if(context != NULL) {
                            if(tintColor != nil) {
                                if(CGColorGetAlpha(tintColor.CGColor) > 0.0f) {
                                    CGContextSetFillColorWithColor(context, [[tintColor colorWithAlphaComponent:0.25] CGColor]);
                                    CGContextSetBlendMode(context, kCGBlendModePlusDarker);
                                    CGContextFillRect(context, CGRectMake(0, 0, buffer1.width, buffer1.height));
                                }
                            }
                            imageRef = CGBitmapContextCreateImage(context);
                            if(imageRef != nil) {
                                image = [UIImage imageWithCGImage:imageRef scale:scale orientation:self.imageOrientation];
                                CGImageRelease(imageRef);
                            }
                            CGContextRelease(context);
                        }
                    }
                }
                free(buffer2.data);
            }
            free(buffer1.data);
        }
    }
    return image;
}

- (void)glb_drawInRect:(CGRect)rect alignment:(GLBUIImageAlignment)alignment {
    return [self glb_drawInRect:rect alignment:alignment corners:UIRectCornerAllCorners radius:0.0f blendMode:kCGBlendModeNormal alpha:1.0f];
}

- (void)glb_drawInRect:(CGRect)rect alignment:(GLBUIImageAlignment)alignment blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha {
    return [self glb_drawInRect:rect alignment:alignment corners:UIRectCornerAllCorners radius:0.0f blendMode:blendMode alpha:alpha];
}

- (void)glb_drawInRect:(CGRect)rect alignment:(GLBUIImageAlignment)alignment radius:(CGFloat)radius {
    return [self glb_drawInRect:rect alignment:alignment corners:UIRectCornerAllCorners radius:radius blendMode:kCGBlendModeNormal alpha:1.0f];
}

- (void)glb_drawInRect:(CGRect)rect alignment:(GLBUIImageAlignment)alignment radius:(CGFloat)radius blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha {
    return [self glb_drawInRect:rect alignment:alignment corners:UIRectCornerAllCorners radius:radius blendMode:blendMode alpha:alpha];
}

- (void)glb_drawInRect:(CGRect)rect alignment:(GLBUIImageAlignment)alignment corners:(UIRectCorner)corners radius:(CGFloat)radius {
    return [self glb_drawInRect:rect alignment:alignment corners:corners radius:radius blendMode:kCGBlendModeNormal alpha:1.0f];
}

- (void)glb_drawInRect:(CGRect)rect alignment:(GLBUIImageAlignment)alignment corners:(UIRectCorner)corners radius:(CGFloat)radius blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    [path addClip];
    switch(alignment) {
        case GLBUIImageAlignmentStretch: break;
        case GLBUIImageAlignmentAspectFill: rect = GLBRectAspectFillFromBoundsAndSize(rect, self.size); break;
        case GLBUIImageAlignmentAspectFit: rect = GLBRectAspectFitFromBoundsAndSize(rect, self.size); break;
    }
    [self drawInRect:rect blendMode:blendMode alpha:alpha];
    CGContextRestoreGState(contextRef);
}

@end

/*--------------------------------------------------*/
#endif
/*--------------------------------------------------*/
