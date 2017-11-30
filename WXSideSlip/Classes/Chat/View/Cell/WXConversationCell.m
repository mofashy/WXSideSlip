//
//  WXConversationCell.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXConversationCell.h"
#import "WXConversation.h"
#import "WXConversationLayout.h"

@interface WXConversationCell ()
@property (strong, nonatomic) UIImageView *portraitView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UILabel *badgeLabel;
@end

@implementation WXConversationCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.portraitView];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.badgeLabel];
    }
    
    return self;
}

#pragma mark - Getter

- (UIImageView *)portraitView {
    if (!_portraitView) {
        _portraitView = [[UIImageView alloc] init];
        _portraitView.layer.masksToBounds = YES;
        _portraitView.layer.cornerRadius = WX_PORTRAIT_WIDTH_40 / 2.0;
        _portraitView.backgroundColor = WXHEXCOLOR(0xB2B2B2);
    }
    
    return _portraitView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = WX_SYSTEM_FONT_10;
    }
    
    return _timeLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = WX_SYSTEM_FONT_16;
    }
    
    return _nameLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = WX_SYSTEM_FONT_14;
    }
    
    return _messageLabel;
}

- (UILabel *)badgeLabel {
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.font = WX_SYSTEM_FONT_10;
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.textColor = [UIColor whiteColor];
    }
    
    return _badgeLabel;
}

#pragma mark - Setter

- (void)setConversation:(WXConversation *)conversation {
    _conversation = conversation;
    
    self.timeLabel.text = conversation.time;
    self.nameLabel.text = conversation.name;
    self.messageLabel.text = conversation.message;
    self.badgeLabel.text = conversation.badge;
    
    self.portraitView.frame = conversation.layout.portraitFrame;
    self.timeLabel.frame = conversation.layout.timeFrame;
    self.nameLabel.frame = conversation.layout.nameFrame;
    self.messageLabel.frame = conversation.layout.messageFrame;
    self.badgeLabel.frame = conversation.layout.badgeFrame;
    
    self.badgeLabel.layer.cornerRadius = conversation.layout.badgeFrame.size.height / 2.0;
    self.badgeLabel.hidden = conversation.badge.length == 0;
}

@end
