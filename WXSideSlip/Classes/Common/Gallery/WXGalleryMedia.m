//
//  WXGalleryMedia.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/11.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXGalleryMedia.h"

@implementation WXGalleryMedia

+ (instancetype)itemWithDictionary:(NSDictionary *)aDictionary {
    return [[self alloc] initWithDictionary:aDictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:aDictionary];
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
