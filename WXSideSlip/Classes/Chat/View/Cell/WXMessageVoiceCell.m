//
//  WXMessageVoiceCell.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXMessageVoiceCell.h"

@interface WXMessageVoiceCell ()
@property (strong, nonatomic) UIImageView *fileIconView;
@property (strong, nonatomic) UILabel *durationLabel;
@end

@implementation WXMessageVoiceCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.fileIconView];
        [self.contentView addSubview:self.durationLabel];
    }
    
    return self;
}

#pragma mark - Getter

- (UIImageView *)fileIconView {
    if (!_fileIconView) {
        _fileIconView = [[UIImageView alloc] init];
        _fileIconView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _fileIconView;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.font = WX_SYSTEM_FONT_10;
    }
    
    return _durationLabel;
}

@end
