//
//  WXConversationLayout.h
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WXConversationLayout : NSObject
@property (assign, nonatomic) CGRect frame;

@property (assign, nonatomic) CGRect portraitFrame;
@property (assign, nonatomic) CGRect timeFrame;
@property (assign, nonatomic) CGRect nameFrame;
@property (assign, nonatomic) CGRect messageFrame;
@property (assign, nonatomic) CGRect badgeFrame;
@end
