//
//  WXGalleryView.h
//  WXSideSlip
//
//  Created by macOS on 2017/10/11.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WXGalleryMedia;

@interface WXGalleryView : UIView

+ (instancetype)sharedView;

- (void)showMedias:(NSArray<WXGalleryMedia *> *)medias
      inImageViews:(NSArray<UIImageView *> *)imageViews
           atIndex:(NSInteger)index;
@end
