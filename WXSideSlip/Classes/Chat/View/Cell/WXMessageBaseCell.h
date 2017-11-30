//
//  WXMessageBaseCell.h
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WXMessage.h"

@interface WXMessageBaseCell : UITableViewCell
@property (strong, nonatomic) UIImageView *portraitView;
@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UIImageView *bubbleView;

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) UIButton *statusButton;

@property (strong, nonatomic) WXMessage *message;
@end
