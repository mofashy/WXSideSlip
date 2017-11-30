//
//  WXMessageImageCell.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXMessageImageCell.h"

@interface WXMessageImageCell ()
@property (strong, nonatomic) UIImageView *thumbnailImageView;
@end

@implementation WXMessageImageCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.thumbnailImageView];
    }
    
    return self;
}

#pragma mark - Getter

- (UIImageView *)thumbnailImageView {
    if (!_thumbnailImageView) {
        _thumbnailImageView = [[UIImageView alloc] init];
        _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _thumbnailImageView;
}

@end
