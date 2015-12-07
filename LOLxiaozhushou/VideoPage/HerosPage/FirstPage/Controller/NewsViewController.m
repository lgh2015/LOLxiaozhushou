//
//  NewsViewController.m
//  项目
//
//  Created by 李国灏 on 15/11/4.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webV = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webV.backgroundColor =[UIColor whiteColor];
    if ([self.webViewStr length]>30) {
        [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewStr]]];
    }
    else{
        NSString *str =[NSString stringWithFormat:@"http://qt.qq.com/static/pages/news/phone/%@",self.webViewStr];
        webV.frame = CGRectMake(0, k_screenWidth*-64, self.view.bounds.size.width, self.view.bounds.size.height+k_screenWidth*(15+64));
        [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    }
     [self.view addSubview:webV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
