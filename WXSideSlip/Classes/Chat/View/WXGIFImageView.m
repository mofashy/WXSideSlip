//
//  WXGIFImageView.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXGIFImageView.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface WXGIFImageView ()
@property (strong, nonatomic) __attribute__((NSObject))  CGImageSourceRef imageSource;
@property (assign, nonatomic) NSUInteger loopCount;
@end

@implementation WXGIFImageView

- (void)commonInit {
    _imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)_gifData, (__bridge CFDictionaryRef)@{(NSString *)kCGImageSourceShouldCache: @NO});
    
    NSAssert(_imageSource, @"Failed to 'CGImageSourceCreateWithData' for animated GIF data");
    
    CFStringRef imageSourceContainerType = CGImageSourceGetType(_imageSource);
    BOOL isGIFData = UTTypeConformsTo(imageSourceContainerType, kUTTypeGIF);
    NSAssert(isGIFData, @"Seems not GIF data");
    
    NSDictionary *imageProperties = (__bridge_transfer NSDictionary *)CGImageSourceCopyProperties(_imageSource, NULL);
    _loopCount = [[[imageProperties objectForKey:(id)kCGImagePropertyGIFDictionary] objectForKey:(id)kCGImagePropertyGIFLoopCount] unsignedIntegerValue];
    
    size_t imageCount = CGImageSourceGetCount(_imageSource);
    NSUInteger skippedFrameCount = 0;
    
    for (size_t i = 0; i < imageCount; i++) {
        @autoreleasepool {
            CGImageRef frameImageRef = CGImageSourceCreateImageAtIndex(_imageSource, i, NULL);
            if (frameImageRef) {
                UIImage *frameImage = [UIImage imageWithCGImage:frameImageRef];
                
                if (frameImage) {
                    if (!self.posterImage) {
                        _posterImage = frameImage;
                        _size = _posterImage.size;
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

@end
