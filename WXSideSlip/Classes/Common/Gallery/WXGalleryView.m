//
//  WXGalleryView.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/11.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXGalleryView.h"
#import "WXGalleryPhotoCell.h"
#import "WXGalleryVideoCell.h"
#import "WXGalleryMedia.h"
#import "WXProgressView.h"

typedef NS_ENUM(NSUInteger, WXGalleryAnimationTypes) {
    WXGalleryAnimationTypesPresent = 0,
    WXGalleryAnimationTypesDismiss,
};

static NSString * const photoIdentifier = @"WXGalleryPhotoCell";
static NSString * const videoIdentifier = @"WXGalleryVideoCell";

@interface WXGalleryView () <UICollectionViewDataSource, UICollectionViewDelegate, WXGalleryPhotoCellDelegate, WXGalleryVideoCellDelegate>
@property (strong, nonatomic) WXProgressView *progressView;
@end

@implementation WXGalleryView
{
    UICollectionView *_collectionView;
    UIView *_bottomView;
    UIView *_contentView;
    UILabel *_indexLabel;
    UIImageView *_tmpImageView;
    NSArray<WXGalleryMedia *> *_medias;
    NSMutableArray *_imageRects;
    NSInteger _index;
}

+ (instancetype)sharedView {
    static WXGalleryView *sharedView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedView = [[self alloc] init];
    });
    
    return sharedView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.frame = [UIScreen mainScreen].bounds;
        
        [self initCollectionView];
        [self initBottomView];
        [self initIndexLabel];
        [self initTmpImageview];
        
#if DEBUG
        _progressView = [[WXProgressView alloc] initWithFrame:CGRectMake(100, 30, 50, 50)];
//        [self addSubview:_progressView];
        
        UISlider *slider = [[UISlider alloc] init];
        slider.frame = CGRectMake(10, 100, CGRectGetWidth(self.frame) - 20, 20);
        [slider addTarget:self action:@selector(moveSlider:) forControlEvents:UIControlEventValueChanged];
//        [self addSubview:slider];
#endif
    }
    return self;
}

- (void)moveSlider:(UISlider *)sender {
    _progressView.progress = sender.value;
}

- (void)initCollectionView {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGFloat itemWidth = screenSize.width + WX_MARGIN_8 * 2;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, screenSize.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-WX_MARGIN_8, 0, itemWidth, CGRectGetHeight(self.frame)) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointZero;
    _collectionView.alwaysBounceHorizontal = YES;
    _collectionView.hidden = YES;
    [self addSubview:_collectionView];
    
    
    
    [_collectionView registerClass:[WXGalleryPhotoCell class] forCellWithReuseIdentifier:photoIdentifier];
    [_collectionView registerClass:[WXGalleryVideoCell class] forCellWithReuseIdentifier:videoIdentifier];
}

- (void)initBottomView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 40, CGRectGetWidth(self.frame), 40)];
    _bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bottomView];
    
    _contentView = [[UIView alloc] initWithFrame:_bottomView.bounds];
    _contentView.backgroundColor = [UIColor blackColor];
    _contentView.alpha = 0.4;
    [_bottomView addSubview:_contentView];
}

- (void)initIndexLabel {
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    _indexLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    _indexLabel.font = [UIFont systemFontOfSize:16];
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_indexLabel];
    
    [_bottomView addConstraint:[NSLayoutConstraint constraintWithItem:_indexLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-15.0f]];
    [_bottomView addConstraint:[NSLayoutConstraint constraintWithItem:_indexLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
}

- (void)initTmpImageview {
    _tmpImageView = [[UIImageView alloc] init];
    _tmpImageView.backgroundColor = WXHEXCOLOR(0xB2B2B2);
    _tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)showMedias:(NSArray<WXGalleryMedia *> *)medias inImageViews:(NSArray<UIImageView *> *)imageViews atIndex:(NSInteger)index {
    _medias = medias;
    _index = index;
    
    [_collectionView setContentSize:CGSizeMake(CGRectGetWidth(_collectionView.frame) * imageViews.count, CGRectGetHeight(_collectionView.frame))];
    [_collectionView reloadData];
    [_collectionView setContentOffset:CGPointMake(CGRectGetWidth(_collectionView.frame) * index, 0) animated:NO];
    
    _indexLabel.text = [NSString stringWithFormat:@"%ld / %ld", (long)(_index + 1), (long)imageViews.count];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    _imageRects = [NSMutableArray arrayWithCapacity:imageViews.count];
    for (UIImageView *imageView in imageViews) {
        [_imageRects addObject:[NSValue valueWithCGRect:[imageView.superview convertRect:imageView.frame toView:keyWindow]]];
    }
    
    [self animationWithType:WXGalleryAnimationTypesPresent];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _medias.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        WXGalleryPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        
        return cell;
    } else {
        WXGalleryVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:videoIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self animationWithType:WXGalleryAnimationTypesDismiss];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _index = scrollView.contentOffset.x / (CGRectGetWidth(self.frame) + WX_MARGIN_8 * 2) + 0.5;
    _indexLabel.text = [NSString stringWithFormat:@"%ld / %ld", (long)(_index + 1), (long)_medias.count];
}

#pragma mark - WXGalleryPhotoCellDelegate

- (void)didTapPhotoCell:(WXGalleryPhotoCell *)cell {
    [self animationWithType:WXGalleryAnimationTypesDismiss];
}

- (void)didLongPressPhotoCell:(WXGalleryPhotoCell *)cell {
    
}

- (void)didCompleteSaveImage:(NSError *)error {
    
}

#pragma mark - WXGalleryVideoCellDelegate

- (void)didTapVideoCell:(WXGalleryVideoCell *)cell {
    [self animationWithType:WXGalleryAnimationTypesDismiss];
}

- (void)didLongPressVideoCell:(WXGalleryVideoCell *)cell {
    
}

- (void)didCompleteSaveVideo:(NSError *)error {
    
}

#pragma mark - Private

- (void)animationWithType:(WXGalleryAnimationTypes)type {
    _bottomView.hidden = YES;
    _collectionView.hidden = YES;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    WXGalleryMedia *media = [_medias objectAtIndex:_index];
    CGRect rect = [[_imageRects objectAtIndex:_index] CGRectValue];
    CGSize size = media.thumbnailSize;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = screenSize;
    }
    CGSize newSize = CGSizeMake(screenSize.width, screenSize.width / size.width * size.height);
    CGRect newRect = CGRectMake(0, (screenSize.height - newSize.height) / 2.0, newSize.width, newSize.height);
    
    if (type == WXGalleryAnimationTypesPresent) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        self.backgroundColor = [UIColor blackColor];
        _tmpImageView.frame = rect;
        [self addSubview:_tmpImageView];
        [UIView animateWithDuration:0.3 animations:^{
            _tmpImageView.frame = newRect;
        } completion:^(BOOL finished) {
            if (finished) {
                _bottomView.hidden = NO;
                _collectionView.hidden = NO;
                [_tmpImageView removeFromSuperview];
            }
        }];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        self.backgroundColor = [UIColor clearColor];
        _tmpImageView.frame = newRect;
        [self addSubview:_tmpImageView];
        [UIView animateWithDuration:0.3 animations:^{
            _tmpImageView.frame = rect;
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
                _imageRects = nil;
            }
        }];
    }
}

@end
