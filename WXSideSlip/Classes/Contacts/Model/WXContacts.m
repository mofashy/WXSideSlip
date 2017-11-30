//
//  WXContacts.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/11.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXContacts.h"
#import "WXContactsLayout.h"

@implementation WXContacts
{
    WXContactsLayout *_layout;
}

+ (instancetype)contactsWithDictionary:(NSDictionary *)aDictionary {
    return [[self alloc] initWithDictionary:aDictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:aDictionary];
        
        [self initLayout];
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)initLayout {
    _layout = [[WXContactsLayout alloc] init];
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    _layout.portraitFrame = CGRectMake(WX_MARGIN_15, WX_MARGIN_10, WX_PORTRAIT_WIDTH_30, WX_PORTRAIT_WIDTH_30);
    
    CGSize nameSize = [_name sizeWithAttributes:@{NSFontAttributeName: WX_SYSTEM_FONT_16}];
    _layout.nameFrame = CGRectMake(WX_MARGIN_15 + WX_PORTRAIT_WIDTH_30 + WX_MARGIN_10, WX_MARGIN_10 + (WX_PORTRAIT_WIDTH_30 - nameSize.height) / 2.0, nameSize.width, nameSize.height);
    
    _layout.frame = CGRectMake(0, 0, screenWidth, WX_MARGIN_10 * 2 + WX_PORTRAIT_WIDTH_30);
}

#pragma mark - Getter

- (WXContactsLayout *)layout {
    return _layout;
}

@end
