//
//  WXContacts.h
//  WXSideSlip
//
//  Created by macOS on 2017/10/11.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WXContactsLayout;

@interface WXContacts : NSObject
@property (copy, nonatomic) NSString *portraitUrl;
@property (copy, nonatomic) NSString *name;

@property (strong, nonatomic) WXContactsLayout *layout;

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;
+ (instancetype)contactsWithDictionary:(NSDictionary *)aDictionary;
@end
