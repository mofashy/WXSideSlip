//
//  WXGalleryVideoCell.h
//  WXSideSlip
//
//  Created by macOS on 2017/10/11.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WXGalleryMedia;
@protocol WXGalleryVideoCellDelegate;

@interface WXGalleryVideoCell : UICollectionViewCell
@property (strong, nonatomic) WXGalleryMedia *galleryMedia;
@property (weak, nonatomic) id <WXGalleryVideoCellDelegate> delegate;

- (void)preLoading;
- (void)startLoading;
- (void)cancelLoading;

- (void)play;
- (void)pause;
- (void)stop;

- (void)saveVideoToAlbum;
@end


@protocol WXGalleryVideoCellDelegate <NSObject>
- (void)didTapVideoCell:(WXGalleryVideoCell *)cell;
- (void)didLongPressVideoCell:(WXGalleryVideoCell *)cell;
- (void)didCompleteSaveVideo:(NSError *)error;
@end
