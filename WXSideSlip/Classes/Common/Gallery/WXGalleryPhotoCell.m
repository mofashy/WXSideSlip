//
//  WXGalleryPhotoCell.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/11.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXGalleryPhotoCell.h"
#import "WXProgressView.h"

#import "WXGalleryMedia.h"

static const CGFloat kMaxZoomScale = 2.0;

@interface WXGalleryPhotoCell () <UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) WXProgressView *progressView;
@end

@implementation WXGalleryPhotoCell

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.scrollView];
        self.scrollView.frame = CGRectMake(WX_MARGIN_8, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        [self.scrollView addSubview:self.imageView];
        self.imageView.frame = self.scrollView.bounds;
        
        [self.contentView addSubview:self.progressView];
        self.progressView.center = self.imageView.center;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        [doubleTap setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        longPress.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPress];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    
    return self;
}

- (void)prepareForReuse {
//    [self.imageView sd_cancelCurrentImageLoad];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - Action

- (void)singleTapAction:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(didTapPhotoCell:)]) {
        __weak __typeof(self)weakSelf = self;
        [self.delegate didTapPhotoCell:weakSelf];
    }
}

- (void)doubleTapAction:(UITapGestureRecognizer *)recognizer {
    if (self.scrollView.zoomScale >= kMaxZoomScale) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint point = [recognizer locationInView:self];
        [self.scrollView zoomToRect:CGRectMake(point.x - 40, point.y - 40, 80, 80) animated:YES];
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(didLongPressPhotoCell:)]) {
        __weak __typeof(self)weakSelf = self;
        [self.delegate didLongPressPhotoCell:weakSelf];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if ([self.delegate respondsToSelector:@selector(didCompleteSaveImage:)]) {
        [self.delegate didCompleteSaveImage:error];
    }
}

#pragma mark - Public method

- (void)preLoading {
//    NSURL *thumbnailUrl = [NSURL URLWithString:self.galleryMedia.thumbnailUrl];
//    NSURL *originalUrl = [NSURL URLWithString:self.galleryMedia.originalUrl];
//
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    if ([manager diskImageExistsForURL:originalUrl]) {  // 已缓存大图
//        self.progressView.hidden = YES;
//        [self.imageView sd_setImageWithURL:originalUrl];
//    } else if ([manager diskImageExistsForURL:thumbnailUrl]) {  // 已缓存缩略图
//        self.progressView.hidden = NO;
//        [self.imageView sd_setImageWithURL:thumbnailUrl];
//    } else {    // 使用占位图
//        self.progressView.hidden = NO;
//        self.imageView.image = nil;
//    }
}

- (void)startLoading {
//    NSURL *originalUrl = [NSURL URLWithString:self.galleryMedia.originalUrl];
//
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    if (![manager diskImageExistsForURL:originalUrl]) {
//        __weak __typeof(self)weakSelf = self;
//        [manager downloadImageWithURL:originalUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            if ([originalUrl.absoluteString isEqualToString:weakSelf.galleryMedia.originalUrl]) {
//                CGFloat progress = receivedSize * 1.0 / expectedSize;
//                weakSelf.progressView.progress = progress;
//            }
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            if (!error && image && [imageURL.absoluteString isEqualToString:weakSelf.galleryMedia.originalUrl]) {
//                weakSelf.progressView.hidden = YES;
//                weakSelf.imageView.image = image;
//            }
//        }];
//    }
}

- (void)cancelLoading {
    
}

- (void)cancelZooming {
    [self.scrollView setZoomScale:1.0 animated:NO];
}

- (void)saveImageToAlbum {
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

#pragma mark - Getter   |   Setter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.maximumZoomScale = kMaxZoomScale;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = WXHEXCOLOR(0xB2B2B2);
    }
    
    return _imageView;
}

- (WXProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[WXProgressView alloc] init];
    }
    
    return _progressView;
}

@end
