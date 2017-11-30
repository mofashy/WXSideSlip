//
//  WXGalleryVideoCell.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/11.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXGalleryVideoCell.h"
#import "WXProgressView.h"

#import "WXDownloadManager.h"

#import "WXGalleryMedia.h"

#import <AVFoundation/AVFoundation.h>

static const NSString *kPlayerItemContext;

@interface WXGalleryVideoCell ()
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) UIImageView *thumbnailView;
@property (strong, nonatomic) WXProgressView *progressView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *bigPlayButton;
@property (strong, nonatomic) UIButton *smalPlayButton;
@property (strong, nonatomic) UISlider *slider;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *durationLabel;

@property (copy, nonatomic) NSString *videoPath;
@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic) id timeObserver;

@property (assign, nonatomic, getter=isPlaying) BOOL playing;
@property (assign, nonatomic, getter=isEnded) BOOL ended;

@property (strong, nonatomic) WXDownloadManager *downloadManager;
@end

@implementation WXGalleryVideoCell

#pragma mark - Life cycle

- (void)dealloc {
    [self pause];
    [self.playerLayer removeFromSuperlayer];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player removeTimeObserver:self.timeObserver];
    self.timeObserver = nil;
    self.playerLayer = nil;
    self.player = nil;
    self.thumbnailView = nil;
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self.contentView.layer addSublayer:self.playerLayer];
        self.playerLayer.frame = CGRectMake(WX_MARGIN_8, 0, CGRectGetWidth(self.bounds) - WX_MARGIN_8 * 2, CGRectGetHeight(self.bounds));
        
        [self.contentView addSubview:self.thumbnailView];
        self.thumbnailView.frame = self.playerLayer.frame;
        
        [self.contentView addSubview:self.progressView];
        self.progressView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        
        [self.contentView addSubview:self.closeButton];
        [self.contentView addSubview:self.bigPlayButton];
        [self.contentView addSubview:self.smalPlayButton];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.slider];
        [self.contentView addSubview:self.durationLabel];
        
        self.closeButton.frame = CGRectMake(20, 20, 40, 40);
        self.bigPlayButton.frame = CGRectMake((CGRectGetWidth(self.frame) - 60) / 2.0f, (CGRectGetHeight(self.frame) - 60) / 2.0f, 60, 60);
        self.smalPlayButton.frame = CGRectMake(30, CGRectGetHeight(self.frame) - 30 - 30, 30, 30);
        
        CGSize timeSize = [self.timeLabel sizeThatFits:CGSizeZero];
        self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.smalPlayButton.frame) + 10, CGRectGetMinY(self.smalPlayButton.frame) + (CGRectGetHeight(self.smalPlayButton.frame) - timeSize.height) / 2.0f, timeSize.width + 5, timeSize.height);
        
        CGSize durationSize = [self.durationLabel sizeThatFits:CGSizeZero];
        self.durationLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 30 - durationSize.width - 5, CGRectGetMinY(self.timeLabel.frame), durationSize.width + 5, durationSize.height);
        
        CGFloat startX = CGRectGetMaxX(self.timeLabel.frame) + 5;
        self.slider.frame = CGRectMake(startX, CGRectGetMinY(self.smalPlayButton.frame) + (CGRectGetHeight(self.smalPlayButton.frame) - 20) / 2.0f, CGRectGetMinX(self.durationLabel.frame) - 5 - startX, 20);
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        __weak __typeof(self)weakSelf = self;
        self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float current = CMTimeGetSeconds(time);
            float duration = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
            if (current && duration) {
                weakSelf.timeLabel.text = [weakSelf timeStringFromseconds:(int)round(current)];
                [weakSelf.slider setValue:duration animated:YES];
            }
        }];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        longPress.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPress];
        
        _downloadManager = [WXDownloadManager manager];
    }
    
    return self;
}

#pragma mark - Public method

- (void)preLoading {
    self.thumbnailView.hidden = NO;
    self.smalPlayButton.hidden = NO;
    self.closeButton.hidden = YES;
    self.smalPlayButton.hidden = YES;
    self.timeLabel.hidden = YES;
    self.durationLabel.hidden = YES;
    self.slider.hidden = YES;
    self.playing = NO;
    
//    NSURL *thumbnailUrl = [NSURL URLWithString:self.galleryMedia.thumbnailUrl];
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    if ([manager diskImageExistsForURL:thumbnailUrl]) { // 缩略图
//        [self.thumbnailView sd_setImageWithURL:thumbnailUrl];
//    } else {    // 占位图
//        self.thumbnailView.image = [UIImage imageNamed:@"ic_picture_loading"];
//    }
//    
//    NSURL *originalUrl = [NSURL URLWithString:self.galleryMedia.originalUrl];
//    if ([self.downloadManager diskVideoExistsForURL:originalUrl]) {
//        [self configPlayItemWithURL:originalUrl];
//    } else {
//        self.bigPlayButton.hidden = YES;
//    }
}

- (void)startLoading {
    NSURL *originalUrl = [NSURL URLWithString:self.galleryMedia.originalUrl];
    if (![self.downloadManager diskVideoExistsForURL:originalUrl]) {
        __weak __typeof(self)weakSelf = self;
        [self.downloadManager download:originalUrl progress:^(float progress) {
            weakSelf.progressView.hidden = NO;
            weakSelf.progressView.progress = progress;
        } complete:^(NSError *error, NSString *path) {
            weakSelf.videoPath = [path copy];
            if (!error && path) {
                weakSelf.progressView.hidden = YES;
                weakSelf.playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];
#if TARGET_OS_SIMULATOR
                weakSelf.bigPlayButton.hidden = NO;
#else
                [weakSelf.playerItem addObserver:weakSelf forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:&kPlayerItemContext];
                [weakSelf play];
#endif
            }
        }];
    } else {
        [self configPlayItemWithURL:originalUrl];
    }
}

- (void)cancelLoading {
    [self.downloadManager cancelDownload];
}

- (void)play {
    self.playing = YES;
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

- (void)stop {
    self.playing = NO;
    self.ended = NO;
    [self pause];
    [self deallocPlayer];
}

- (void)saveVideoToAlbum {
    UISaveVideoAtPathToSavedPhotosAlbum(self.videoPath, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
}

#pragma mark - KVO

- (void)didPlayToEnd:(NSNotification *)noti {
    self.ended = YES;
    self.bigPlayButton.hidden = NO;
    self.smalPlayButton.selected = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == &kPlayerItemContext) {
        if ([keyPath isEqualToString:@"status"]) {
            if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
                self.bigPlayButton.hidden = YES;
                self.smalPlayButton.selected = YES;
                self.thumbnailView.hidden = YES;
                self.playing = YES;
                
                int seconds = round(CMTimeGetSeconds(self.playerItem.duration));
                self.durationLabel.text = [self timeStringFromseconds:seconds];
                self.slider.maximumValue = CMTimeGetSeconds(self.playerItem.duration);
            }
        }
    }
}

#pragma mark - Action

- (void)singleTapAction:(UITapGestureRecognizer *)sender {
    self.closeButton.hidden = !self.closeButton.isHidden;
    BOOL isHidden = self.closeButton.isHidden;
    
    if (self.isPlaying) {
        self.smalPlayButton.hidden = isHidden;
        self.timeLabel.hidden = isHidden;
        self.durationLabel.hidden = isHidden;
        self.slider.hidden = isHidden;
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(didLongPressVideoCell:)]) {
        __weak __typeof(self)weakSelf = self;
        [self.delegate didLongPressVideoCell:weakSelf];
    }
}

- (void)valueChanged:(UISlider *)sender {
    self.timeLabel.text = [self timeStringFromseconds:(int)sender.value];
    [self pause];
    [self.player seekToTime:CMTimeMake(sender.value * CMTimeGetSeconds(self.playerItem.duration), 1.0)];
    [self.player play];
}

- (void)didClickBigPlayButton:(UIButton *)sender {
    [self play];
}

- (void)didClickSmallPlayButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.bigPlayButton.hidden = sender.isSelected;
    
    if (sender.selected) {
        if (self.ended) {
            [self.player seekToTime:kCMTimeZero];
            self.ended = NO;
        }
        [self.player play];
    } else {
        [self.player pause];
    }
}

- (void)didClickCloseButton:(UIButton *)sender {
    [self didPlayToEnd:nil];
    
    if ([self.delegate respondsToSelector:@selector(didTapVideoCell:)]) {
        __weak __typeof(self)weakSelf = self;
        [self.delegate didTapVideoCell:weakSelf];
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if ([self.delegate respondsToSelector:@selector(didCompleteSaveVideo:)]) {
        [self.delegate didCompleteSaveVideo:error];
    }
}

#pragma mark - Helper

- (NSString *)timeStringFromseconds:(int)seconds {
    return [NSString stringWithFormat:@"%02d:%02d", seconds / 60, seconds % 60];
}

- (void)deallocPlayer {
    self.timeLabel.text = @"00:00";
    self.durationLabel.text = @"00:00";
    [self.slider setValue:0.0 animated:NO];
    
    self.closeButton.hidden = YES;
    self.timeLabel.hidden = YES;
    self.smalPlayButton.hidden = YES;
    self.slider.hidden = YES;
    self.bigPlayButton.hidden = YES;
    self.durationLabel.hidden = YES;
    
    self.playing = NO;
    self.ended = NO;
}

- (void)configPlayItemWithURL:(NSURL *)URL {
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
    }
    
    self.progressView.hidden = YES;
    self.bigPlayButton.hidden = NO;
    self.videoPath = [self.downloadManager cachePathForURL:URL];
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:self.videoPath]];
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:&kPlayerItemContext];
}

#pragma mark - Getter   |   Setter

- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    
    return _player;
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    }
    
    return _playerLayer;
}

- (UIImageView *)thumbnailView {
    if (!_thumbnailView) {
        _thumbnailView = [[UIImageView alloc] init];
        _thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
        _thumbnailView.backgroundColor = WXHEXCOLOR(0xB2B2B2);
    }
    
    return _thumbnailView;
}

- (WXProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[WXProgressView alloc] init];
    }
    
    return _progressView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        _closeButton.hidden = YES;
        [_closeButton setImage:WX_BUNDLE_IMAGE(@"WXGallery", @"nav_close") forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(didClickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}

- (UIButton *)bigPlayButton {
    if (!_bigPlayButton) {
        _bigPlayButton = [[UIButton alloc] init];
        _bigPlayButton.hidden = YES;
        [_bigPlayButton setImage:WX_BUNDLE_IMAGE(@"WXGallery", @"play_large") forState:UIControlStateNormal];
        [_bigPlayButton addTarget:self action:@selector(didClickBigPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _bigPlayButton;
}

- (UIButton *)smalPlayButton {
    if (!_smalPlayButton) {
        _smalPlayButton = [[UIButton alloc] init];
        _smalPlayButton.hidden = YES;
        [_smalPlayButton setImage:WX_BUNDLE_IMAGE(@"WXGallery", @"play_small") forState:UIControlStateNormal];
        [_smalPlayButton setImage:WX_BUNDLE_IMAGE(@"WXGallery", @"pause_small") forState:UIControlStateSelected];
        [_smalPlayButton addTarget:self action:@selector(didClickSmallPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _smalPlayButton;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.text = @"00:00";
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.hidden = YES;
    }
    
    return _timeLabel;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.font = [UIFont systemFontOfSize:10];
        _durationLabel.text = @"00:00";
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.hidden = YES;
    }
    
    return _durationLabel;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue = 0.0;
        _slider.maximumValue = 1.0;
        _slider.tintColor = [UIColor whiteColor];
        [_slider setThumbImage:WX_BUNDLE_IMAGE(@"WXGallery", @"slider_thumb") forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        _slider.hidden = YES;
    }
    
    return _slider;
}

@end
