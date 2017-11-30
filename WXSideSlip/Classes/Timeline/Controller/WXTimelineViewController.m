//
//  WXTimelineViewController.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/9.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXTimelineViewController.h"
#import "WXTimeline.h"
#import "WXTimelineCell.h"
#import "WXTimelineLayout.h"
#import "WXGalleryView.h"
#import "WXGalleryMedia.h"

static NSString * const reuseIdentifier = @"WXTimelineCell";

@interface WXTimelineViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, WXTimelineCellDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation WXTimelineViewController

#pragma mark - Life cycle

- (void)loadView {
    [super loadView];
    
    [self initCollectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self simulateData];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self.dataArray removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark - Init components

- (void)initCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.view.frame) - WX_TABBAR_HEIGHT - WX_STATUSBAR_HEIGHT - WX_NAVIGATIONBAR_HEIGHT) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[WXTimelineCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    if (@available(iOS 11.0, *)) {
        [_collectionView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // Refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(requestData:) forControlEvents:UIControlEventValueChanged];
    _collectionView.refreshControl = refreshControl;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WXTimelineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.timeline = [self.dataArray objectAtIndex:indexPath.item];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    WXTimeline *timeline = [self.dataArray objectAtIndex:indexPath.item];
    return CGSizeMake(CGRectGetWidth(collectionView.frame), timeline.layout.frame.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 0, 10, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

#pragma mark - WXTimelineCellDelegate

- (void)userWithTimelineCell:(WXTimelineCell *)cell {
    
}

- (void)likeWithTimelineCell:(WXTimelineCell *)cell {
    
}

- (void)replyWithTimelineCell:(WXTimelineCell *)cell {
    
}

- (void)shareWithTimelineCell:(WXTimelineCell *)cell {
    
}

- (void)cell:(WXTimelineCell *)cell didTapImageAtIndex:(NSInteger)index inImageViews:(NSArray<UIImageView *> *)imageViews {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < imageViews.count; i++) {
        [array addObject:[[WXGalleryMedia alloc] init]];
    }
    [[WXGalleryView sharedView] showMedias:array inImageViews:imageViews atIndex:index];
}

#pragma mark - Action

- (void)requestData:(UIRefreshControl *)sender {
    NSLog(@"Begin refresh");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"End refresh");
        [self.dataArray removeAllObjects];
        [self simulateData];
        [self.collectionView reloadData];
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
        WXTimeline *timeline = [WXTimeline timelineWithDictionary:@{@"name": @"human", @"text": [[text substringWithRange:NSMakeRange(loc, len)] stringByAppendingString:@"[哭]#topic#[生气] @wx https://www.baidu.com"], @"imageUrls": imageUrls, @"time": @"15:43"}];
        [self.dataArray addObject:timeline];
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
