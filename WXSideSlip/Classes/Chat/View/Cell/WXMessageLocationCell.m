//
//  WXMessageLocationCell.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXMessageLocationCell.h"
#import <MapKit/MapKit.h>

@interface WXMessageLocationCell ()
@property (strong, nonatomic) MKMapView *mapView;
@end

@implementation WXMessageLocationCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.mapView];
    }
    
    return self;
}

#pragma mark - Getter

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
    }
    
    return _mapView;
}

@end
