//
//  WXGalleryMedia.h
//  WXSideSlip
//
//  Created by macOS on 2017/10/11.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WXGalleryMediaType) {
    WXGalleryMediaTypePhoto = 0,
    WXGalleryMediaTypeVideo,
};

@interface WXGalleryMedia : NSObject
@property (assign, nonatomic) WXGalleryMediaType type;

@property (copy, nonatomic) NSString *mediaId;
@property (copy, nonatomic) NSString *thumbnailUrl;
@property (copy, nonatomic) NSString *originalUrl;
@property (assign, nonatomic) CGSize thumbnailSize;
@property (assign, nonatomic) CGSize originalSize;
@property (assign, nonatomic) long filesize;

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;
+ (instancetype)itemWithDictionary:(NSDictionary *)aDictionary;
@end
