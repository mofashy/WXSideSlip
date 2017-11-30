//
//  WXMenuViewController.h
//  WXSideSlip
//
//  Created by macOS on 2017/8/16.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXMenuViewDelegate;

@interface WXMenuViewController : UIViewController
@property (strong, nonatomic) UITableView *tableView IB_DESIGNABLE;
@property (weak, nonatomic) id <WXMenuViewDelegate> delegate;
@end


@protocol WXMenuViewDelegate <NSObject>
- (void)menuViewDidTapUserPortrait;
- (void)menuViewDidSelecRowAtIndexPath:(NSIndexPath *)indexPath;
@end
