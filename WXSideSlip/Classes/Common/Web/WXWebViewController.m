//
//  WXWebViewController.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/12.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXWebViewController.h"
#import <WebKit/WebKit.h>

@interface WXWebViewController () <WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *shareButton;

@property (assign, nonatomic, getter=isDidStartLoading) BOOL didStartLoading;
@end

@implementation WXWebViewController

#pragma mark - Life cycle

- (void)dealloc {
    [self.webView stopLoading];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigationBar];
    [self initWebView];
    [self initProgressView];
    [self initOtherButtons];
    [self setupObservers];
    
    if ([self.url isKindOfClass:[NSString class]]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

- (void)setupObservers {
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Init components

- (void)initNavigationBar {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftButton:)];
}

- (void)initWebView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _webView = [[WKWebView alloc] init];
    _webView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.view.frame) - WX_STATUSBAR_HEIGHT - WX_NAVIGATIONBAR_HEIGHT);
    _webView.navigationDelegate = self;
    _webView.configuration.allowsInlineMediaPlayback = YES;
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
}

- (void)initProgressView {
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 2)];
    _progressView.trackTintColor = [UIColor whiteColor];
    _progressView.progressTintColor = WX_TINT_COLOR;
    [self.view addSubview:_progressView];
}

- (void)initOtherButtons {
//    _closeButton = [[UIButton alloc] init];
//    _closeButton.hidden = YES;
//    _closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
//    [_closeButton addTarget:self action:@selector(didClickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.headNavView addSubview:_closeButton];
//    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.leftBtn.mas_right).offset(5);
//        make.height.and.centerY.equalTo(self.leftBtn);
//        make.width.mas_equalTo(44);
//    }];
//
//    _shareButton = [[UIButton alloc] init];
//    _shareButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    [_shareButton setImage:[UIImage imageNamed:@"share_white"] forState:UIControlStateNormal];
//    [_shareButton addTarget:self action:@selector(didClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.headNavView addSubview:_shareButton];
//    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.rigthBtn.mas_left).offset(-5);
//        make.height.and.centerY.equalTo(self.rigthBtn);
//        make.width.mas_equalTo(44);
//    }];
//
//    [self.headNavView.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.greaterThanOrEqualTo(self.closeButton.mas_right);
//        make.centerX.equalTo(self.headNavView.mas_centerX);
//        make.top.and.bottom.equalTo(self.closeButton);
//        make.right.lessThanOrEqualTo(self.shareButton.mas_left);
//    }];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.didStartLoading = NO;
    self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.progressView setProgress:0.0 animated:NO];
    self.didStartLoading = YES;
    self.progressView.hidden = NO;
    
    if (![webView.URL.absoluteString isEqualToString:self.url]) {
        self.closeButton.hidden = NO;
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.didStartLoading = NO;
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.progressView.hidden = YES;
    });
    
    if (!self.title || self.title.length == 0) {
        self.title = [webView.title copy];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.didStartLoading && object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        float progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        [self.progressView setProgress:progress animated:progress >= self.progressView.progress];
    }
}

#pragma mark - Helper

- (void)clearCache {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        NSArray * types =@[WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeCookies, WKWebsiteDataTypeLocalStorage, WKWebsiteDataTypeSessionStorage];
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *error;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&error];
    }
}

#pragma mark - Action

- (void)didClickLeftButton:(UIButton *)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)didClickRightButton:(UIButton *)sender {
    [self.progressView setProgress:0.0 animated:NO];
    [self clearCache];
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.webView reloadFromOrigin];
    });
}

- (void)didClickCloseButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickShareButton:(UIButton *)sender {
    
}

#pragma mark - Setter

- (void)setUrl:(NSString *)url {
    if (![url isKindOfClass:[NSString class]]) {
        url = @"";
    }
    
    _url = [[url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
