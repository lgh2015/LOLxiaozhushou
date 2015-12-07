//
//  VideoDetailController.m
//  项目
//
//  Created by 李国灏 on 15/11/24.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "VideoDetailController.h"
#import "VideoDetailInfoManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface VideoDetailController ()<UIWebViewDelegate>
@property(nonatomic,strong)NSString *videoStr;
@end

@implementation VideoDetailController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [[VideoDetailInfoManager shareInfoManager]acquireData:self.detailStr completion:^{
        UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        scrollV.showsHorizontalScrollIndicator=NO;
        [self.view addSubview:scrollV];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = self.title11;
        titleLabel.font=[UIFont systemFontOfSize:20];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.numberOfLines=0;
        CGRect labelSize=[titleLabel.text boundingRectWithSize:CGSizeMake(k_screenWidth*355, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil];
        CGFloat contentH = labelSize.size.height;
        titleLabel.frame=CGRectMake(k_screenWidth*10,k_screenWidth*25, k_screenWidth*355, contentH);
        [scrollV addSubview:titleLabel];
        
        self.videoStr = [[VideoDetailInfoManager shareInfoManager]getVideoStr];
        UIWebView *wv=[[UIWebView alloc]initWithFrame:CGRectMake(k_screenWidth*10, k_screenWidth*100, k_screenWidth*355, k_screenWidth*200)];
        wv.scrollView.scrollEnabled=NO;
        [wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.videoStr]]];
        wv.delegate =self;
        [scrollV addSubview:wv];
        
        UILabel *bulletinLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(k_screenWidth*10, k_screenWidth*375,k_screenWidth* 355,k_screenWidth*30)];
        bulletinLabel2.text=@"右上角分享出去也能观看";
        bulletinLabel2.textColor=[UIColor redColor];
        bulletinLabel2.textAlignment=NSTextAlignmentCenter;
        [scrollV addSubview:bulletinLabel2];
        
        if (![self.videoStr containsString:@"qq"]) {
            UILabel *bulletinLabel = [[UILabel alloc]initWithFrame:CGRectMake(k_screenWidth*10, k_screenWidth*325, k_screenWidth*355, k_screenWidth*50)];
            bulletinLabel.font=[UIFont systemFontOfSize:15];
            bulletinLabel.numberOfLines=2;
            bulletinLabel.text=@"本视频请在WIFI环境下观看,若不能播放请用以下链接播放";
            bulletinLabel.textColor=[UIColor redColor];
            bulletinLabel.textAlignment=NSTextAlignmentCenter;
            [scrollV addSubview:bulletinLabel];
            
            UITextView *textV = [[UITextView alloc]initWithFrame:CGRectMake(k_screenWidth*10, k_screenWidth*425, k_screenWidth*355, k_screenWidth*250)];
            textV.text=self.videoStr;
            textV.scrollEnabled=NO;
            textV.textAlignment=NSTextAlignmentCenter;
            textV.editable=NO;
            [scrollV addSubview:textV];
        }
        
        scrollV.contentSize=CGSizeMake(0,k_screenHeight*700);
        
    }];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction)];
    
}
-(void)leftBarButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtonAction:(UIBarButtonItem *)sender
{
    
//    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.title11
                                         images:@[self.shareImage]
                                            url:[NSURL URLWithString:self.videoStr]
                                          title:self.title11
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                       
                   }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
