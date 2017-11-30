//
//  WXConversation.h
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WXConversationLayout;

@interface WXConversation : NSObject
@property (copy, nonatomic) NSString *portraitUrl;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *badge;

@property (strong, nonatomic, readonly) WXConversationLayout *layout;

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;
+ (instancetype)conversationWithDictionary:(NSDictionary *)aDictionary;
@end
