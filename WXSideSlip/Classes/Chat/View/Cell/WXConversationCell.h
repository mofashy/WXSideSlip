//
//  WXConversationCell.h
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WXConversation;

@interface WXConversationCell : UITableViewCell
@property (strong, nonatomic) WXConversation *conversation;
@end
