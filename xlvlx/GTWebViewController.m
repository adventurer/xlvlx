//
//  GTWebViewController.m
//  xlvlx
//
//  Created by 吴洋 on 2020/02/22.
//  Copyright © 2020 吴洋. All rights reserved.
//

#import "GTWebViewController.h"
#import <WebKit/WebKit.h>

@interface GTWebViewController ()
@property(nonatomic,strong,readwrite) WKWebView *sinaWebView;
@property(nonatomic,strong,readwrite) UIProgressView *webProgress;
@end

@implementation GTWebViewController
-(void)dealloc{
    [self.sinaWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",@(self.sinaWebView.frame.origin.y));
    
    self.sinaWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.webProgress = [[UIProgressView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 20)];
    
    [self.sinaWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];
    
    [self.sinaWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.view addSubview:self.sinaWebView];
    [self.view addSubview:self.webProgress];
    // Do any additional setup after loading the view.
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    self.webProgress.progress = self.sinaWebView.estimatedProgress;
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
