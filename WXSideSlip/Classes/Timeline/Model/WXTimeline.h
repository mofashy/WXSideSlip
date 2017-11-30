//
//  WXTimeline.h
//  WXSideSlip
//
//  Created by macOS on 2017/10/9.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WXTimelineLayout;

@interface WXTimeline : NSObject
///MARK: Infos
@property (copy, nonatomic) NSString *portraitUrl;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *time;

///MARK: Contents
@property (copy, nonatomic) NSString *text;
@property (strong, nonatomic) NSArray *imageUrls;

///MARK: Layout
@property (strong, nonatomic, readonly) WXTimelineLayout *layout;

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;
+ (instancetype)timelineWithDictionary:(NSDictionary *)aDictionary;
@end
