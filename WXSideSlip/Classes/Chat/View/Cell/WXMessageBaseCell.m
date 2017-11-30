//
//  WXMessageBaseCell.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXMessageBaseCell.h"

@implementation WXMessageBaseCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.portraitView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.bubbleView];
    }
    
    return self;
}

#pragma mark - Life cycle

- (UIImageView *)portraitView {
    if (!_portraitView) {
        _portraitView = [[UIImageView alloc] init];
        _portraitView.layer.cornerRadius = WX_PORTRAIT_WIDTH_30 / 2.0;
        _portraitView.layer.masksToBounds = YES;
        _portraitView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _portraitView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = WX_SYSTEM_FONT_12;
    }
    
    return _nameLabel;
}

- (UIImageView *)bubbleView {
    if (!_bubbleView) {
        _bubbleView = [[UIImageView alloc] init];
        _bubbleView.contentMode = UIViewContentModeScaleToFill;
    }
    
    return _bubbleView;
}

@end
