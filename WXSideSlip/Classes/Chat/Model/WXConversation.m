//
//  WXConversation.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXConversation.h"
#import "WXConversationLayout.h"

@implementation WXConversation
{
    WXConversationLayout *_layout;
}

+ (instancetype)conversationWithDictionary:(NSDictionary *)aDictionary {
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
    _layout = [[WXConversationLayout alloc] init];
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    _layout.portraitFrame = CGRectMake(WX_MARGIN_15, WX_MARGIN_10, WX_PORTRAIT_WIDTH_40, WX_PORTRAIT_WIDTH_40);
    
    CGSize nameSize = [_name boundingRectWithSize:CGSizeMake(screenWidth - WX_MARGIN_15 * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: WX_SYSTEM_FONT_16} context:NULL].size;
    CGSize messageSize = CGSizeZero;
    if (_message.length > 0) {
        messageSize = [[_message substringToIndex:1] boundingRectWithSize:CGSizeMake(screenWidth - WX_MARGIN_15 * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: WX_SYSTEM_FONT_14} context:NULL].size;
    }
    
    CGFloat startX = WX_MARGIN_15 + WX_PORTRAIT_WIDTH_40 + WX_MARGIN_10;
    CGFloat startY = WX_MARGIN_10 + (WX_PORTRAIT_WIDTH_40 - nameSize.height - messageSize.height - WX_MARGIN_5) / 2.0;
    
    if (CGSizeEqualToSize(messageSize, CGSizeZero)) {
        startY = WX_MARGIN_10;
    }
    
    _layout.nameFrame = CGRectMake(startX, startY, nameSize.width, nameSize.height);
    _layout.messageFrame = CGRectMake(startX, startY + nameSize.height + WX_MARGIN_5, messageSize.width, messageSize.height);
    
    CGSize timeSize = [_time sizeWithAttributes:@{NSFontAttributeName: WX_SYSTEM_FONT_10}];
    _layout.timeFrame = CGRectMake(screenWidth - WX_MARGIN_15 - timeSize.width, startY + (nameSize.height - timeSize.height) / 2.0, timeSize.width, timeSize.height);
    
    startY += nameSize.height + WX_MARGIN_5;
    
    CGSize badgeSize = [_badge boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: WX_SYSTEM_FONT_10} context:NULL].size;
    CGFloat badgeWidth = MAX(badgeSize.width, badgeSize.height) + WX_MARGIN_4;
    
    
    startY += (messageSize.height - badgeWidth) / 2.0;
    if (_message.length == 0) {
        startY = nameSize.height + WX_MARGIN_15;
    }
    
    _layout.badgeFrame = CGRectMake(screenWidth - WX_MARGIN_15 - badgeWidth, startY, badgeWidth, badgeSize.height + WX_MARGIN_4);
    
    CGRect messageFrame = _layout.messageFrame;
    messageFrame.size.width = CGRectGetMinX(_layout.badgeFrame) - startX - WX_MARGIN_10;
    _layout.messageFrame = messageFrame;
    
    _layout.frame = CGRectMake(0, 0, screenWidth, WX_PORTRAIT_WIDTH_40 + WX_MARGIN_20);
}

#pragma mark - Getter

- (WXConversationLayout *)layout {
    return _layout;
}

@end
