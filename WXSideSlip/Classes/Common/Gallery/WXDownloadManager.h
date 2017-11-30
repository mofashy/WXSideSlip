//
//  WXDownloadManager.h
//  WXSideSlip
//
//  Created by macOS on 2017/10/11.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXDownloadManager : NSObject
+ (instancetype)manager;

- (BOOL)diskVideoExistsForURL:(NSURL *)URL;
- (NSString *)cachePathForURL:(NSURL *)URL;

- (void)download:(NSURL *)URL progress:(void (^)(float progress))progress complete:(void (^)(NSError *error, NSString *path))complete;
- (void)cancelDownload;

- (float)allVideoFilesize;
- (void)removeVideosFromDisk;
@end
