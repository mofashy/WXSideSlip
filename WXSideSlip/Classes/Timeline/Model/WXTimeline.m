//
//  WXTimeline.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/9.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXTimeline.h"
#import "WXTimelineLayout.h"

@implementation WXTimeline
{
    WXTimelineLayout *_layout;
}

+ (instancetype)timelineWithDictionary:(NSDictionary *)aDictionary {
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
    _layout = [[WXTimelineLayout alloc] init];
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    _layout.portraitFrame = CGRectMake(WX_MARGIN_15, WX_MARGIN_10, WX_PORTRAIT_WIDTH_40, WX_PORTRAIT_WIDTH_40);
    
    CGSize nameSize = [_name sizeWithAttributes:@{NSFontAttributeName: WX_SYSTEM_FONT_14}];
    CGSize timeSize = [_time sizeWithAttributes:@{NSFontAttributeName: WX_SYSTEM_FONT_12}];
    
    CGFloat startX = WX_MARGIN_15 + WX_PORTRAIT_WIDTH_40 + WX_MARGIN_10;
    CGFloat startY = WX_MARGIN_10 + (WX_PORTRAIT_WIDTH_40 - nameSize.height - timeSize.height - WX_MARGIN_5) / 2.0;
    
    if (CGSizeEqualToSize(timeSize, CGSizeZero)) {
        startY = WX_MARGIN_10;
    }
    
    _layout.nameFrame = CGRectMake(startX, startY, nameSize.width, nameSize.height);
    _layout.timeFrame = CGRectMake(startX, startY + nameSize.height + WX_MARGIN_5, timeSize.width, timeSize.height);
    
    CGSize textSize = [_text boundingRectWithSize:CGSizeMake(screenWidth - WX_MARGIN_15 * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: WX_SYSTEM_FONT_16} context:nil].size;
    _layout.textFrame = CGRectMake(WX_MARGIN_15, WX_MARGIN_10 + WX_PORTRAIT_WIDTH_40 + WX_MARGIN_10, textSize.width, textSize.height);
    
    startX = WX_MARGIN_15;
    startY = WX_MARGIN_10 + WX_PORTRAIT_WIDTH_40 + WX_MARGIN_10 + textSize.height + WX_MARGIN_10;
    CGFloat imageWidth = (screenWidth - startX * 2 - WX_MARGIN_5 * 2) / 3.0;
    NSMutableArray *imageFrames = [NSMutableArray arrayWithCapacity:_imageUrls.count];
    for (int i = 1; i <= _imageUrls.count; i++) {
        CGRect imageFrame = CGRectMake(startX, startY, imageWidth, imageWidth);
        [imageFrames addObject:[NSValue valueWithCGRect:imageFrame]];
        startX += imageWidth + WX_MARGIN_5;
        if (i % 3 == 0 && i != _imageUrls.count) {
            startX = WX_MARGIN_15;
            startY += imageWidth + WX_MARGIN_5;
        }
    }
    _layout.imageFrames = imageFrames;
    
    if (_imageUrls.count > 0) {
        startY += WX_MARGIN_5 + imageWidth;
    }
    
    CGFloat buttonWidth = screenWidth / 3.0;
    CGRect buttonBounds = CGRectMake(0, 0, buttonWidth, WX_TIMELINE_BUTTON_HEIGHT);
    _layout.likeFrame = CGRectOffset(buttonBounds, 0, startY + WX_MARGIN_10);
    _layout.replyFrame = CGRectOffset(buttonBounds, buttonWidth, startY + WX_MARGIN_10);
    _layout.shareFrame = CGRectOffset(buttonBounds, buttonWidth * 2, startY + WX_MARGIN_10);
    
    _layout.frame = CGRectMake(0, 0, screenWidth, startY + WX_MARGIN_10 + WX_TIMELINE_BUTTON_HEIGHT);
}

#pragma mark - Getter

- (WXTimelineLayout *)layout {
    return _layout;
}

@end
