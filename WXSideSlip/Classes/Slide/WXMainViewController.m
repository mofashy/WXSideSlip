//
//  WXMainViewController.m
//  WXSideSlip
//
//  Created by macOS on 2017/8/16.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXMainViewController.h"
#import "WXMenuViewController.h"
#import "WXHomeViewController.h"

typedef NS_ENUM(NSUInteger, WXViewType) {
    WXViewTypeMenu,
    WXViewTypeHome,
};

static const CGFloat kMinProportion = 0.3;
static const CGFloat kMaxProportion = 0.78;

@interface WXMainViewController () <UIGestureRecognizerDelegate, WXMenuViewDelegate>
@property (strong, nonatomic) WXMenuViewController *menuVC;
@property (strong, nonatomic) WXHomeViewController *homeVC;
@property (assign, nonatomic) CGPoint menuCenter;
@property (assign, nonatomic) CGPoint homeCenter;
@property (assign, nonatomic) CGFloat distance;

@property (strong, nonatomic) UIView *maskView;
@end

@implementation WXMainViewController

#pragma mark - Appearance

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Life cycle

- (void)loadView {
    [super loadView];
    
    [self initMenuViewController];
    [self initHomeViewController];
    [self initMaskView];
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

#pragma mark - Init components

- (void)initMenuViewController {
    _menuVC = [[WXMenuViewController alloc] init];
    _menuVC.delegate = self;
    [self addChildViewController:_menuVC];
    [self.view addSubview:_menuVC.view];
    
    CGFloat menuWidth = CGRectGetWidth(self.view.frame) * kMaxProportion;
    _menuVC.view.frame = CGRectMake(-menuWidth * kMinProportion, 0, menuWidth, CGRectGetHeight(self.view.frame));
    _menuCenter = _menuVC.view.center;
}

- (void)initHomeViewController {
    _homeVC = [[WXHomeViewController alloc] init];
    [self addChildViewController:_homeVC];
    [self.view addSubview:_homeVC.view];
    _homeVC.view.frame = self.view.bounds;
    _homeCenter = _homeVC.view.center;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHomeView:)];
    panGesture.delegate = self;
    [_homeVC.view addGestureRecognizer:panGesture];
}

- (void)initMaskView {
    _maskView = [[UIView alloc] init];
    _maskView.hidden = YES;
    _maskView.frame = self.view.bounds;
    [_homeVC.view addSubview:_maskView];
    [_homeVC.view bringSubviewToFront:_maskView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHomeView:)];
    [_maskView addGestureRecognizer:tapGesture];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UINavigationController *nav = self.homeVC.selectedViewController;
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view];
    
    if (nav.viewControllers.count > 1) {    // Push到新界面后不再响应Pan手势
        return NO;
    } if (self.distance == 0.0f && velocity.x < 0.0f) { // 收起后不再响应Pan手势的左滑
        return NO;
    }
    
    return YES;
}

#pragma mark - Action

- (void)panHomeView:(UIPanGestureRecognizer *)sender {
    CGFloat x = [sender translationInView:sender.view].x;
    CGFloat trueDistance = MIN(MAX(self.distance + x, 0), CGRectGetWidth(self.view.frame) * kMaxProportion);
    
    if (sender.state == UIGestureRecognizerStateEnded ||
        sender.state == UIGestureRecognizerStateCancelled) {
        if (trueDistance > CGRectGetWidth(self.view.frame) * kMaxProportion * 0.5) {
            // 展开
            [self switchTo:WXViewTypeMenu animated:YES];
        } else {
            // 收起
            [self switchTo:WXViewTypeHome animated:YES];
        }
        
        return;
    }
    
    sender.view.center = CGPointMake(self.homeCenter.x + trueDistance, self.homeCenter.y);
    self.menuVC.view.center = CGPointMake(self.menuCenter.x + trueDistance * kMinProportion, self.menuCenter.y);
}

- (void)tapHomeView:(UITapGestureRecognizer *)sender {
    if (self.distance == CGRectGetWidth(self.view.frame) * kMaxProportion) {
        [self switchTo:WXViewTypeHome animated:YES];
    }
}

- (void)switchTo:(WXViewType)viewType animated:(BOOL)animated {
    if (viewType == WXViewTypeMenu) {
        self.distance = CGRectGetWidth(self.view.frame) * kMaxProportion;
    } else {
        self.distance = 0;
    }
    
    [UIView animateWithDuration:animated ? 0.2 : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.homeVC.view.center = CGPointMake(self.homeCenter.x + self.distance, self.homeCenter.y);
        self.menuVC.view.center = CGPointMake(self.menuCenter.x + self.distance * kMinProportion, self.menuCenter.y);
    } completion:^(BOOL finished) {
        if (finished) {
            self.maskView.hidden = viewType == WXViewTypeHome;
        }
    }];
}

#pragma mark - WXMenuViewDelegate

- (void)menuViewDidTapUserPortrait {
    [self switchTo:WXViewTypeHome animated:YES];
}

- (void)menuViewDidSelecRowAtIndexPath:(NSIndexPath *)indexPath {
    [self switchTo:WXViewTypeHome animated:YES];
    UINavigationController *nav = (UINavigationController *)self.homeVC.selectedViewController;
    UIViewController *VC = [[UIViewController alloc] init];
    VC.view.backgroundColor = [UIColor whiteColor];
    VC.title = [NSString stringWithFormat:@"VC%d", arc4random_uniform(99)];
    VC.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:VC animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
