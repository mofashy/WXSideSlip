//
//  WXMessageGifCell.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXMessageGifCell.h"

@interface WXMessageGifCell ()
@property (assign, nonatomic) NSInteger gifIndex;
@property (strong, nonatomic) UIImageView *gifImageView;
@end

@implementation WXMessageGifCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.gifImageView];
    }
    
    return self;
}

#pragma mark - Getter

- (UIImageView *)gifImageView {
    if (!_gifImageView) {
        _gifImageView = [[UIImageView alloc] init];
        _gifImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _gifImageView;
}

@end
