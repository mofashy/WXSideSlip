//
//  WXGIFImageView.h
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXGIFImageView : UIImageView
@property (strong, nonatomic) NSData *gifData;
@property (assign, nonatomic) NSInteger gifIndex;
@property (strong, nonatomic) UIImage *posterImage;
@property (assign, nonatomic) CGSize size;

- (void)startGIFAnimating;
- (void)stopGIFAnimating;
- (BOOL)isGIFAnimating;
@end
