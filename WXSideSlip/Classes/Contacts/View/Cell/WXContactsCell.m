//
//  WXContactsCell.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/11.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXContactsCell.h"
#import "WXContacts.h"
#import "WXContactsLayout.h"

@interface WXContactsCell ()
@property (strong, nonatomic) UIImageView *portraitView;
@property (strong, nonatomic) UILabel *nameLabel;
@end

@implementation WXContactsCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.portraitView];
        [self.contentView addSubview:self.nameLabel];
    }
    
    return self;
}

#pragma mark - Getter

- (UIImageView *)portraitView {
    if (!_portraitView) {
        _portraitView = [[UIImageView alloc] init];
        _portraitView.layer.masksToBounds = YES;
        _portraitView.layer.cornerRadius = WX_PORTRAIT_WIDTH_30 / 2.0;
        _portraitView.backgroundColor = WXHEXCOLOR(0xB2B2B2);
    }
    
    return _portraitView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = WX_SYSTEM_FONT_16;
    }
    
    return _nameLabel;
}

#pragma mark - Setter

- (void)setContacts:(WXContacts *)contacts {
    _contacts = contacts;
    
    self.nameLabel.text = contacts.name;
    
    self.portraitView.frame = contacts.layout.portraitFrame;
    self.nameLabel.frame = contacts.layout.nameFrame;
}

@end
