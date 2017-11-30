//
//  WXMessageTextCell.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXMessageTextCell.h"

@interface WXMessageTextCell ()
@property (strong, nonatomic) UILabel *attrTextLabel;
@end

@implementation WXMessageTextCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.attrTextLabel];
    }
    
    return self;
}

#pragma mark - Getter

- (UILabel *)attrTextLabel {
    if (!_attrTextLabel) {
        _attrTextLabel = [[UILabel alloc] init];
        _attrTextLabel.font = WX_SYSTEM_FONT_14;
    }
    
    return _attrTextLabel;
}

@end
