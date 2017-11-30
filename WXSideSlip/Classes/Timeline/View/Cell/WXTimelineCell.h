//
//  WXTimelineCell.h
//  WXSideSlip
//
//  Created by macOS on 2017/10/9.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WXTimeline;
@protocol WXTimelineCellDelegate;

@interface WXTimelineCell : UICollectionViewCell
@property (strong, nonatomic) WXTimeline *timeline;

@property (weak, nonatomic) id <WXTimelineCellDelegate> delegate;
@end


@protocol WXTimelineCellDelegate <NSObject>
- (void)userWithTimelineCell:(WXTimelineCell *)cell;
- (void)likeWithTimelineCell:(WXTimelineCell *)cell;
- (void)replyWithTimelineCell:(WXTimelineCell *)cell;
- (void)shareWithTimelineCell:(WXTimelineCell *)cell;
- (void)cell:(WXTimelineCell *)cell didTapImageAtIndex:(NSInteger)index inImageViews:(NSArray<UIImageView *> *)imageViews;
@end
