//
//  WXConversationListViewController.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/10.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXConversationListViewController.h"
#import "WXMessageViewController.h"
#import "WXConversation.h"
#import "WXConversationCell.h"
#import "WXConversationLayout.h"

static NSString * const reuseIdentifier = @"WXConversationCell";

@interface WXConversationListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation WXConversationListViewController

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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.view.frame) - WX_TABBAR_HEIGHT - WX_STATUSBAR_HEIGHT - WX_NAVIGATIONBAR_HEIGHT)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[WXConversationCell class] forCellReuseIdentifier:reuseIdentifier];
    
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
    WXConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.conversation = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Enter chatting
    WXMessageViewController *messageVC = [[WXMessageViewController alloc] init];
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXConversation *conversation = [self.dataArray objectAtIndex:indexPath.row];
    
    return conversation.layout.frame.size.height;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *markAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"标记" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    
    UITableViewRowAction *delAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    
    return @[delAction, markAction];
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
    NSString *message = @"";
    NSString *portraitUrl = @"https://mp.weixin.qq.com/debug/wxadoc/design/image/1emphasis.dont.png?t=2017118";
    NSString *badge = @"";
    NSString *time = @"";
    
    for (int i = 0; i < 20; i++) {
        badge = [NSString stringWithFormat:@"%ld", (long)arc4random_uniform(100)];
        time = [NSString stringWithFormat:@"%02ld:%02ld", (long)arc4random_uniform(24), (long)arc4random_uniform(60)];
        if (i % 3 == 0) {
            message = @"An unlucky fox fell into a well, It was quite deep, so he could not get out by himself.";
        } else {
            message = @"";
        }
        WXConversation *conversation = [WXConversation conversationWithDictionary:@{@"name": @"human", @"message": message, @"portraitUrl": portraitUrl, @"badge": badge, @"time": time}];
        [self.dataArray addObject:conversation];
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
