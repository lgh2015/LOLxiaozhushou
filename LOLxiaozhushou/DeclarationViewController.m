//
//  DeclarationViewController.m
//  项目
//
//  Created by 李国灏 on 15/12/5.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "DeclarationViewController.h"

@interface DeclarationViewController ()

@end

@implementation DeclarationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UILabel *label1 =[[UILabel alloc]initWithFrame:CGRectMake(k_screenWidth* 70, k_screenWidth*70, k_screenWidth*235, k_screenWidth*50)];
    label1.text=@"免责声明";
    label1.textAlignment=NSTextAlignmentCenter;
    label1.font=[UIFont systemFontOfSize:22];
    [self.view addSubview:label1];

    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(k_screenWidth*5, k_screenWidth*40, k_screenWidth*80, k_screenWidth*40)];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn];

    UILabel *label =[[UILabel alloc]init];
    label.numberOfLines=0;
    label.font=[UIFont systemFontOfSize:17];
    label.text=@"    本APP所有内容，包活文字、图片、视频、均在网上搜集。访问者可将本APP提供的内容或服务用于个人学习、研究或欣赏, 以及其他非商业性或非盈利性用途，但同时应遵守著作权法及其他相关法律的规定, 不得侵犯本APP及相关权利人的合法权利。除此以外，将本APP任何内容或服务用于其他用途时，必须征得本APP及相关权利人的书面许可。在使用本APP前, 请您务必仔细阅读并透彻理解本声明。你可以选择不使用这款产品, 但如果您使用这款产品,都将被视作已无条件接受本声明所涉全部内容。任何单位或个人认为APP内容可能涉嫌到侵犯其合法权益, 应该及时向本APP提出书面通知, 本APP作为学术交流不作为任何盈利的手段, 相关涉嫌侵权的内容, 希望告知。本APP是出于传递更多信息的目的。";
    CGRect labelrect =[label.text boundingRectWithSize:CGSizeMake(k_screenWidth*355, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil];
    label.frame =CGRectMake(k_screenWidth*20, k_screenWidth*140, k_screenWidth*335, k_screenWidth*labelrect.size.height);
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
