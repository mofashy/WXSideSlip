//
//  WXContactsViewController.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/11.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXContactsViewController.h"
#import "WXContacts.h"
#import "WXContactsCell.h"
#import "WXContactsLayout.h"
#import "WXWebViewController.h"

static NSString * const reuseIdentifier = @"WXContactsCell";

@interface WXContactsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSArray *sectionTitles;
@end

@implementation WXContactsViewController

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
    _tableView.sectionIndexColor = WX_TINT_COLOR;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[WXContactsCell class] forCellReuseIdentifier:reuseIdentifier];
    
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

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionTitles;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.contacts = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WXWebViewController *webVC = [[WXWebViewController alloc] init];
    webVC.url = @"https://www.baidu.com";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 26;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sectionTitles objectAtIndex:section];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *markAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"备注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    
    return @[markAction];
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
    NSString *characters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString *name = @"";
    NSString *portraitUrl = @"https://mp.weixin.qq.com/debug/wxadoc/design/image/1emphasis.dont.png?t=2017118";
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < characters.length; i++) {
        name = [[characters substringWithRange:NSMakeRange(i, 1)] stringByAppendingString:@" human"];
        [array addObject:@{@"name": name, @"portraitUrl": portraitUrl}];
    }
    
    [self groupingAndSortingContacts:array];
}

- (void)groupingAndSortingContacts:(NSArray *)array {
    NSMutableArray *contactsArray = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        WXContacts *contacts = [WXContacts contactsWithDictionary:dict];
        [contactsArray addObject:contacts];
    }
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    // A-Z,#
    NSArray *sectionTitles = [collation sectionTitles];
    NSInteger sectionTitlesCount = [sectionTitles count];
    
    // 初始化分组数组
    NSMutableArray *sectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [sectionsArray addObject:array];
    }
    
    // 根据名字分组
    for (WXContacts *contacts in contactsArray) {
        NSInteger sectionNumber = 0;
        sectionNumber = [collation sectionForObject:contacts collationStringSelector:@selector(name)];
        
        NSMutableArray *sectionNames = sectionsArray[sectionNumber];
        [sectionNames addObject:contacts];
    }
    
    // 组内排序
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = sectionsArray[index];
        NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(name)];
        sectionsArray[index] = sortedPersonArrayForSection;
    }
    
    // 排除空的数组
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        if (((NSMutableArray *)(sectionsArray[index])).count != 0) {
            [finalArray addObject:sectionsArray[index]];
            [indexArray addObject:sectionTitles[index]];
        }
    }
    
    self.dataArray = finalArray;
    self.sectionTitles = indexArray;
}

#pragma mark - Getter

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

@end
