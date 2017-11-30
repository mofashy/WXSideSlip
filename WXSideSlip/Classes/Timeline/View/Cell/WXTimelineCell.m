//
//  WXTimelineCell.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/9.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXTimelineCell.h"
#import "WXTimeline.h"
#import "WXTimelineLayout.h"

static const NSInteger kImageTagOffset = 100;

@interface WXTimelineCell ()
///MARK: Infos
@property (strong, nonatomic) UIImageView *portraitView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *timeLabel;

///MARK: Contents - 1 Text
@property (strong, nonatomic) UILabel *textLabel;
///MARK: Contents - 2 Sudoku
@property (strong, nonatomic) NSArray *imageViews;

///MARK: Actions
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UIButton *replyButton;
@property (strong, nonatomic) UIButton *shareButton;
@end

@implementation WXTimelineCell

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.portraitView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.likeButton];
        [self.contentView addSubview:self.replyButton];
        [self.contentView addSubview:self.shareButton];
        
        NSMutableArray *imageViews = [NSMutableArray array];
        for (int i = 0; i < 9; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = kImageTagOffset + i;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImageView:)]];
            [self.contentView addSubview:imageView];
            [imageViews addObject:imageView];
        }
        
        self.imageViews = imageViews;
        
    }
    return self;
}

#pragma mark - Action

- (void)didTapImageView:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(cell:didTapImageAtIndex:inImageViews:)]) {
        __weak __typeof(self)weakSelf = self;
        NSMutableArray *imageViews = [NSMutableArray arrayWithCapacity:self.imageViews.count];
        for (int i = 0; i < self.timeline.imageUrls.count; i++) {
            [imageViews addObject:self.imageViews[i]];
        }
        [self.delegate cell:weakSelf didTapImageAtIndex:sender.view.tag - kImageTagOffset inImageViews:imageViews];
    }
}

- (void)didTapPortraitView:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(userWithTimelineCell:)]) {
        __weak __typeof(self)weakSelf = self;
        [self.delegate userWithTimelineCell:weakSelf];
    }
}

- (void)didClickLikeButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(likeWithTimelineCell:)]) {
        __weak __typeof(self)weakSelf = self;
        [self.delegate likeWithTimelineCell:weakSelf];
    }
}

- (void)didClickReplyButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(replyWithTimelineCell:)]) {
        __weak __typeof(self)weakSelf = self;
        [self.delegate replyWithTimelineCell:weakSelf];
    }
}

- (void)didClickShareButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shareWithTimelineCell:)]) {
        __weak __typeof(self)weakSelf = self;
        [self.delegate shareWithTimelineCell:weakSelf];
    }
}

#pragma mark - Setter

- (void)setTimeline:(WXTimeline *)timeline {
    _timeline = timeline;
    
    self.nameLabel.text = timeline.name;
    self.timeLabel.text = timeline.time;
    self.textLabel.text = timeline.text;
    
    self.portraitView.frame = timeline.layout.portraitFrame;
    self.nameLabel.frame = timeline.layout.nameFrame;
    self.timeLabel.frame = timeline.layout.timeFrame;
    
    self.textLabel.frame = timeline.layout.textFrame;
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView *imageView = (UIImageView *)self.imageViews[i];
        imageView.backgroundColor = WXHEXCOLOR(0xB2B2B2);
        imageView.hidden = i >= timeline.imageUrls.count;
        if (i < timeline.imageUrls.count) {
            [imageView setFrame:[timeline.layout.imageFrames[i] CGRectValue]];
        }
    }
    
    self.likeButton.frame = timeline.layout.likeFrame;
    self.replyButton.frame = timeline.layout.replyFrame;
    self.shareButton.frame = timeline.layout.shareFrame;
}

#pragma mark - Getter

- (UIImageView *)portraitView {
    if (!_portraitView) {
        _portraitView = [[UIImageView alloc] init];
        _portraitView.layer.masksToBounds = YES;
        _portraitView.layer.cornerRadius = WX_PORTRAIT_WIDTH_40 / 2.0;
        _portraitView.backgroundColor = WXHEXCOLOR(0xB2B2B2);
        _portraitView.userInteractionEnabled = YES;
        [_portraitView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPortraitView:)]];
    }
    
    return _portraitView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = WX_SYSTEM_FONT_14;
    }
    
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = WX_SYSTEM_FONT_12;
    }
    
    return _timeLabel;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = WX_SYSTEM_FONT_16;
        _textLabel.numberOfLines = 0;
    }
    
    return _textLabel;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [[UIButton alloc] init];
        [_likeButton setTitle:@"like" forState:UIControlStateNormal];
        [_likeButton setImage:nil forState:UIControlStateNormal];
        [_likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_likeButton addTarget:self action:@selector(didClickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _likeButton;
}

- (UIButton *)replyButton {
    if (!_replyButton) {
        _replyButton = [[UIButton alloc] init];
        [_replyButton setTitle:@"reply" forState:UIControlStateNormal];
        [_replyButton setImage:nil forState:UIControlStateNormal];
        [_replyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_replyButton addTarget:self action:@selector(didClickReplyButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _replyButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] init];
        [_shareButton setTitle:@"share" forState:UIControlStateNormal];
        [_shareButton setImage:nil forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(didClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _shareButton;
}

@end
