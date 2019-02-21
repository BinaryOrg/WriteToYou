//
//  UIImage+Blur.m
//
//  Created by André Schneider on 10.07.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "UIImage+Blur.h"

@implementation UIImage (Blur)

- (UIImage *)blurredImage {
    return [self blurredImageWithRadius:3.f];
}

- (UIImage *)blurredImageWithRadius:(CGFloat)radius {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return returnImage;
}


@end
