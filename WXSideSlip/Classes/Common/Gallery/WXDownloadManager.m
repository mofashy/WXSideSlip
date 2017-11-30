//
//  WXDownloadManager.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/11.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXDownloadManager.h"

static NSString * const kDirectory = @"alfvideos";

@interface WXDownloadManager () <NSURLSessionDownloadDelegate>
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSURLSession *URLSession;
@property (strong, nonatomic) NSData *resumeData;

@property (strong, nonatomic) NSURL *URL;
@property (copy, nonatomic) void (^progress)(float progress);
@property (copy, nonatomic) void (^complete)(NSError *error, NSString *path);
@end

@implementation WXDownloadManager

#pragma mark - Life cycle

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

+ (instancetype)manager {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _URLSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return self;
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = totalBytesWritten / (float)totalBytesExpectedToWrite;
    if (self.progress) {
        self.progress(progress);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSError *error = nil;
    NSString *cachePath = [self cachePathForURL:self.URL];
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:cachePath error:&error];
    NSAssert(error, @"Fail to move video");
    if (!error) {
        if (self.complete) {
            self.complete(nil, cachePath);
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    if (self.complete) {
        self.complete(error, nil);
    }
}

#pragma mark - Public method

- (BOOL)diskVideoExistsForURL:(NSURL *)URL {
    NSParameterAssert(URL);
    NSString *cachePath = [self cachePathForURL:URL];
    return [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
}

- (void)download:(NSURL *)URL progress:(void (^)(float))progress complete:(void (^)(NSError *, NSString *))complete {
    NSParameterAssert(URL);
    if (![URL isKindOfClass:[NSURL class]] && complete) {
        complete([NSError errorWithDomain:@"wx.video" code:505 userInfo:nil], nil);
    }
    self.URL = URL;
    self.progress = [progress copy];
    self.complete = [complete copy];
    
    NSString *cachePath = [self cachePathForURL:URL];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        if (complete) {
            complete(nil, cachePath);
        }
        
        if (self.downloadTask) {
            [self.downloadTask cancel];
        }
    } else {
        if (self.downloadTask && [URL.absoluteString isEqualToString:self.URL.absoluteString]) {
            self.downloadTask = [self.URLSession downloadTaskWithResumeData:self.resumeData];
        } else {
            self.downloadTask = [self.URLSession downloadTaskWithURL:URL];
            self.resumeData = nil;
        }
        
        [self.downloadTask resume];
    }
}

- (void)cancelDownload {
    if (self.downloadTask) {
        __weak __typeof(self)weakSelf = self;
        [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            weakSelf.resumeData = resumeData;
        }];
    }
}

- (float)allVideoFilesize {
    float filesize = 0;
    NSError *error = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *directoryPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kDirectory];
    NSArray *contents = [manager contentsOfDirectoryAtPath:directoryPath error:&error];
    NSAssert(error, @"Fail to get contents in directory");
    if (!error) {
        for (NSString *content in contents) {
            error = nil;
            NSDictionary *attributes = [manager attributesOfItemAtPath:[directoryPath stringByAppendingPathComponent:content] error:&error];
            NSAssert(error, @"Fail to get attributes of file");
            if (!error) {
                filesize += [attributes fileSize];
            }
        }
    }
    
    return filesize / 1024.0;
}

- (void)removeVideosFromDisk {
    NSError *error = nil;
    NSString *directoryPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kDirectory];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *contents = [manager contentsOfDirectoryAtPath:directoryPath error:&error];
    NSAssert(error, @"Fail to get contents in directory");
    if (!error) {
        for (NSString *content in contents) {
            NSString *path = [directoryPath stringByAppendingPathComponent:content];
            [manager removeItemAtPath:path error:nil];
        }
    }
}

- (NSString *)cachePathForURL:(NSURL *)URL {
    NSString *URLString = [[URL.absoluteString componentsSeparatedByString:@"/"] lastObject];
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *directoryPath = [cachePath stringByAppendingPathComponent:kDirectory];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:directoryPath]) {
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [directoryPath stringByAppendingPathComponent:URLString];
    
    return filePath;
}

@end
