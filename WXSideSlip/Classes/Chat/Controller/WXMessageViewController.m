//
//  WXMessageViewController.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXMessageViewController.h"
#import "WXMessage.h"
#import "WXMessageTextCell.h"
#import "WXMessageLayout.h"

static NSString * const reuseIdentifier = @"WXMessageTextCell";

@interface WXMessageViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation WXMessageViewController

#pragma mark - Life cycle

- (void)loadView {
    [super loadView];
    
    [self initTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self simulateData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - Init components

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.view.frame) - WX_STATUSBAR_HEIGHT - WX_NAVIGATIONBAR_HEIGHT)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[WXMessageTextCell class] forCellReuseIdentifier:reuseIdentifier];
    
    if (@available(iOS 11.0, *)) {
        [_tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // Refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(requestData:) forControlEvents:UIControlEventValueChanged];
    _tableView.refreshControl = refreshControl;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXMessageTextCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
//    cell.timeline = [self.dataArray objectAtIndex:indexPath.item];
//    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Action

- (void)requestData:(UIRefreshControl *)sender {
    NSLog(@"Begin refresh");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"End refresh");
        [sender endRefreshing];
    });
}

#pragma mark - Simulate

- (void)simulateData {
    NSString *text = @"An unlucky fox fell into a well, It was quite deep, so he could not get out by himself.\nA goat came. He asked the fox:”what are you doing? The fox said : \"There will  be no water, so I jumped down to get some water. Why don’t you jump down, too?\"\nThe goat  jumped into the well.\nBut the fox jumped on the goat’s back and out of the well. \"Good-bye, friend,\" said the fox. \"Remember next time don’t trust the advice of a man in difficulties.\" ";
    NSString *imageUrl = @"https://mp.weixin.qq.com/debug/wxadoc/design/image/1emphasis.dont.png?t=2017118";
    
    for (int i = 0; i < 20; i++) {
        uint32_t loc = arc4random_uniform((uint32_t)text.length - 50);
        uint32_t len = arc4random_uniform((uint32_t)text.length - loc);
        uint32_t count = arc4random_uniform(10);
        NSMutableArray *imageUrls = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            [imageUrls addObject:imageUrl];
        }
//        WXMessage *message = [WXMessage timelineWithDictionary:@{@"name": @"human", @"text": [text substringWithRange:NSMakeRange(loc, len)], @"imageUrls": imageUrls, @"time": @"15:43"}];
//        [self.dataArray addObject:message];
    }
}

#pragma mark - Getter

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

@end
