//
//  WXGalleryPhotoCell.h
//  WXSideSlip
//
//  Created by macOS on 2017/10/11.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WXGalleryMedia;
@protocol WXGalleryPhotoCellDelegate;

@interface WXGalleryPhotoCell : UICollectionViewCell
@property (strong, nonatomic) WXGalleryMedia *galleryMedia;
@property (weak, nonatomic) id <WXGalleryPhotoCellDelegate> delegate;

- (void)preLoading;

- (void)startLoading;
- (void)cancelLoading;

- (void)cancelZooming;

- (void)saveImageToAlbum;
@end

@protocol WXGalleryPhotoCellDelegate <NSObject>
- (void)didTapPhotoCell:(WXGalleryPhotoCell *)cell;
- (void)didLongPressPhotoCell:(WXGalleryPhotoCell *)cell;
- (void)didCompleteSaveImage:(NSError *)error;
@end
