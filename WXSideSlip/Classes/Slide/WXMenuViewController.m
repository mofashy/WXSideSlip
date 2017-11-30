//
//  WXMenuViewController.m
//  WXSideSlip
//
//  Created by macOS on 2017/8/16.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXMenuViewController.h"

static NSString * const reuseIdentifier = @"WXMenuViewCell";

@interface WXMenuViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIImageView *portraitView;
@property (strong, nonatomic) UILabel *descriptionLabel;
@end

@implementation WXMenuViewController

#pragma mark - Life cycle

- (void)loadView {
    [super loadView];
    
    [self initTableView];
    [self initHeaderView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = 220;
    CGFloat portraitWidth = 90;
    
    self.tableView.frame = self.view.bounds;
    self.headerView.frame = CGRectMake(0, 0, width, height);
    self.portraitView.frame = CGRectMake((width - portraitWidth) / 2.0, (height - portraitWidth) / 2.0, portraitWidth, portraitWidth);
    self.descriptionLabel.frame = CGRectMake(10, CGRectGetMaxY(self.portraitView.frame) + 20, width - 20, 17);
}

#pragma mark - Init components

- (void)initTableView {
    _tableView = [[UITableView alloc] init];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.frame = self.view.bounds;
    
    if (@available(iOS 11.0, *)) {
        [_tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}

- (void)initHeaderView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = 220;
    CGFloat portraitWidth = 90;
    
    _headerView = [[UIView alloc] init];
    _headerView.frame = CGRectMake(0, 0, width, height);
    self.tableView.tableHeaderView = _headerView;
    
    _portraitView = [[UIImageView alloc] init];
    _portraitView.frame = CGRectMake((width - portraitWidth) / 2.0, (height - portraitWidth) / 2.0, portraitWidth, portraitWidth);
    _portraitView.backgroundColor = WXHEXCOLOR(0x353535);
    _portraitView.layer.cornerRadius = portraitWidth / 2.0;
    _portraitView.layer.masksToBounds = YES;
    _portraitView.userInteractionEnabled = YES;
    [_portraitView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPortraitView:)]];
    [_headerView addSubview:_portraitView];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.frame = CGRectMake(10, CGRectGetMaxY(_portraitView.frame) + 20, width - 20, 17);
    _descriptionLabel.font = [UIFont systemFontOfSize:16];
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    _descriptionLabel.text = @"There is personal descriptions...";
    [_headerView addSubview:_descriptionLabel];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.textLabel.text = indexPath.description;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(menuViewDidSelecRowAtIndexPath:)]) {
        [self.delegate menuViewDidSelecRowAtIndexPath:indexPath];
    }
}

#pragma mark - Action

- (void)tapPortraitView:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(menuViewDidTapUserPortrait)]) {
        [self.delegate menuViewDidTapUserPortrait];
    }
}

@end
