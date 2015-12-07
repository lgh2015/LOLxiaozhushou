//
//  questionViewController.m
//  项目
//
//  Created by 李国灏 on 15/12/5.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "questionViewController.h"

@interface questionViewController ()

@end

@implementation questionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UILabel *label1 =[[UILabel alloc]initWithFrame:CGRectMake(k_screenWidth*70, k_screenWidth*70, k_screenWidth*235, k_screenWidth*50)];
    label1.text=@"常见问题说明";
    label1.textAlignment=NSTextAlignmentCenter;
    label1.font=[UIFont systemFontOfSize:22];
    [self.view addSubview:label1];
    
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(k_screenWidth*5, k_screenWidth*40, k_screenWidth*80,k_screenWidth* 40)];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    UILabel *label =[[UILabel alloc]init];
    label.numberOfLines=0;
    label.font=[UIFont systemFontOfSize:17];
    label.text=@"   1.网络数据加载不了\n       请检查一下你的网络环境,网络的不稳定,使用流量上网网速过慢,没有网络,等因为外界原因而断掉都会造成网络的数据获取不到或者加载不了.\n 2.有些访问的内容打不开或则打开时间较长\n     请确认你当前的网络环境是否正常或意外断开网络,如果网络正常,则有可能是网络资源的终端出现了故障,对你带来不便,深感遗憾. 本APP追求为你带来最流畅的体验,最强大的功能,有产品一件或者问题反馈联系我们,可以发邮件给我们\n m13418019192_1@163.com ";
    CGRect labelrect =[label.text boundingRectWithSize:CGSizeMake(k_screenWidth*355, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil];
    label.frame =CGRectMake(k_screenWidth*20, k_screenWidth*140,k_screenWidth* 335, k_screenWidth*labelrect.size.height);
    [self.view addSubview:label];
    
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
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
