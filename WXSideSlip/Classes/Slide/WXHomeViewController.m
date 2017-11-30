//
//  WXHomeViewController.m
//  WXSideSlip
//
//  Created by macOS on 2017/9/30.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXHomeViewController.h"
#import "WXTimelineViewController.h"
#import "WXContactsViewController.h"
#import "WXConversationListViewController.h"

@interface WXHomeViewController ()

@end

@implementation WXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = WX_TINT_COLOR;
    
    self.viewControllers = @[[self navWithRootViewControllerClass:[WXConversationListViewController class] title:@"Chat" image:nil selectedImage:nil],
                             [self navWithRootViewControllerClass:[WXContactsViewController class] title:@"Contacts" image:nil selectedImage:nil],
                             [self navWithRootViewControllerClass:[WXTimelineViewController class] title:@"Timeline" image:nil selectedImage:nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UINavigationController *)navWithRootViewControllerClass:(Class)rootViewControllerClass title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    UIViewController *VC = [[rootViewControllerClass alloc] init];
    VC.title = [title copy];
    VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
    nav.navigationBar.barTintColor = WX_TINT_COLOR;
    nav.navigationBar.tintColor = [UIColor whiteColor];
    nav.navigationBar.translucent = NO;
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    return nav;
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
