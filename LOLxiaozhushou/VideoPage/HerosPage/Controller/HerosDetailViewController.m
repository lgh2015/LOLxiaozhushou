//
//  HerosDetailViewController.m
//  项目
//
//  Created by 李国灏 on 15/11/2.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "HerosDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "DetailManager.h"
#import "HerosManager.h"
#import "MBProgressHUD.h"

#define k_Color(r,g,b,h) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:(h/1.0)]

@interface HerosDetailViewController ()

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,assign)NSInteger scrollViewHieght;

@property(nonatomic,strong)UILabel *skillLabel;

@property(nonatomic,strong)NSMutableArray *arr;

@property(nonatomic,strong)NSMutableArray *storyArr;

@property(nonatomic,strong)UIButton *collectionButton;
@end

@implementation HerosDetailViewController

//英雄故事
//名字,售价,头像
//法师 辅助
//攻击条
//技能名字介绍,细节,基本信息
- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *background = [[UIImageView alloc]initWithFrame:self.view.bounds];
    background.image=[UIImage imageNamed:@"jie.jpg"];
    [self.view addSubview:background];
    UIVisualEffectView *visualView=[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualView.frame=[UIScreen mainScreen].bounds;
    [background addSubview:visualView];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    
    MBProgressHUD *mbHUD =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view addSubview:mbHUD];
    [[DetailManager shareInfoManager]acquireData:self.detailStr Completion:^{
        [self setHerosAttribute];
        [self addScrollV];
        //第二个请求完了再赋值
        [[DetailManager shareInfoManager]acquireData:^{
            [self addSkillBtnAndLabel];
            [self setTechAndStory];

        }];

        [self addCollectionBtn];
        [mbHUD hide:YES];
    }];
}
-(void)backAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --添加滚动视图
-(void)addScrollV
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(k_screenWidth*10, k_screenHeight*120, k_screenWidth*355, k_screenHeight*(667-120))];
    self.scrollView.layer.cornerRadius=5;
    [self.view addSubview:self.scrollView];
    
    UILabel *alabel= [[UILabel alloc]initWithFrame:CGRectMake(k_screenWidth*6, k_screenWidth*6, k_screenHeight*220, k_screenWidth*30)];
    alabel.textAlignment=NSTextAlignmentLeft;
    alabel.font=[UIFont systemFontOfSize:15];
    alabel.text=@"技能介绍(点击图标)";
    alabel.textColor=[UIColor purpleColor];
    [self.scrollView addSubview:alabel];
}
#pragma mark --添加技能按钮和技能介绍
-(void)addSkillBtnAndLabel
{
    self.arr = [[DetailManager shareInfoManager]getSkillArr];
    NSMutableArray *picArr =[[DetailManager shareInfoManager]getSkillPicArr];
    for (int i=0; i<5; i++) {
        UIButton *skillBtn = [[UIButton alloc]initWithFrame:CGRectMake(k_screenWidth*5+k_screenWidth*70*i, k_screenWidth*42, k_screenWidth*66, k_screenWidth*66)];
        if (i!=0) {
            UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0,k_screenWidth* 66, k_screenWidth*66)];
            v.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.7];
            v.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skillBtnAction:)];
            [v addGestureRecognizer:tap];
            v.tag=i+100;
            [skillBtn addSubview:v];
        }
        else
        {
            UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, k_screenWidth*66, k_screenWidth*66)];
            v.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0];
            v.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skillBtnAction:)];
            [v addGestureRecognizer:tap];
            v.tag=i+100;
            [skillBtn addSubview:v];
        }
        [skillBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:picArr[i]] forState:UIControlStateNormal];
        skillBtn.layer.cornerRadius=5.0;
        skillBtn.backgroundColor=[UIColor grayColor];
        
        [self.scrollView addSubview:skillBtn];
    }
    self.skillLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.skillLabel.text=self.arr[0];
    self.skillLabel.layer.cornerRadius=5;
    self.skillLabel.font=[UIFont systemFontOfSize:14];
    self.skillLabel.numberOfLines=0;
    NSDictionary *attribute=@{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect labelSize =[self.skillLabel.text boundingRectWithSize:CGSizeMake(k_screenWidth*345, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    self.skillLabel.frame=CGRectMake(k_screenWidth*5, k_screenWidth*130, k_screenWidth*345,labelSize.size.height);
    self.scrollViewHieght=labelSize.size.height+k_screenWidth*130;
    [self.scrollView addSubview:self.skillLabel];
}
#pragma mark--技能按钮触发方法
-(void)skillBtnAction:(UIGestureRecognizer *)sender
{
    self.skillLabel.text=self.arr[sender.view.tag-100];
    for (int i=0; i<5; i++) {
        UIView *view =[self.scrollView viewWithTag:100+i];
        view.alpha=0.7;
        sender.view.alpha=0;
    }
    
    self.skillLabel.font=[UIFont systemFontOfSize:14];
    self.skillLabel.numberOfLines=0;
    NSDictionary *attribute=@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect labelSize =[self.skillLabel.text boundingRectWithSize:CGSizeMake(k_screenWidth*345, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    self.skillLabel.frame=CGRectMake(k_screenWidth*5, k_screenWidth*130, k_screenWidth*345,labelSize.size.height);
    self.scrollViewHieght=labelSize.size.height+k_screenWidth*130;
    
    //重新设置背景技巧的位置
    for (int i=0; i<3; i++) {
        UILabel *la = [self.scrollView viewWithTag:10086+i];
        
        la.frame = CGRectMake(k_screenWidth*10, self.scrollViewHieght+k_screenWidth*15, k_screenWidth*130, k_screenWidth*30);
        self.scrollViewHieght=self.scrollViewHieght+k_screenWidth*(15+30);
        
        UILabel *laa =[self.scrollView viewWithTag:10010+i];
        laa.text=self.storyArr[i];
        laa.numberOfLines=0;
        NSDictionary *attribute4=@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGRect labelSize4 =[laa.text boundingRectWithSize:CGSizeMake(k_screenWidth*345, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute4 context:nil];
        laa.frame=CGRectMake(k_screenWidth*5, self.scrollViewHieght+k_screenWidth*15, k_screenWidth*345,labelSize4.size.height);
        laa.layer.cornerRadius=5;
        self.scrollViewHieght=self.scrollViewHieght+k_screenWidth*15+labelSize4.size.height;
    }
    self.scrollView.contentSize = CGSizeMake(k_screenWidth*355,self.scrollViewHieght+k_screenWidth*70);
}

#pragma mark --收藏按钮
-(void)addCollectionBtn
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"collection.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(collectionAction:)];
    
    for (NSString *name in [[HerosManager shareInfoManager]getNameArr]) {
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:[NSString stringWithFormat:@"hero%@",name]];
        NSData *data =[[NSData alloc]initWithContentsOfFile:filePath];
        if (data!=nil) {
            NSKeyedUnarchiver *unarchiver =[[NSKeyedUnarchiver alloc]initForReadingWithData:data];
            HerosModel *model =[unarchiver decodeObjectForKey:@"heroModel"];
            [self.collectionArr addObject:model];
        }
    }
    //判断刚进来是否有收藏的英雄
    if (self.collectionArr.count==0) {
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"uncollection.png"] ];
    }
    else
    {
        for (HerosModel *model in self.collectionArr) {
            if ([model.herosName isEqualToString:self.modelname]) {
                [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"collection.png"] ];
                break;
            }
            else{
                [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"uncollection.png"] ];
            }
        }
    }
}
#pragma mark --收藏按钮触发方法
-(void)collectionAction:(UIBarButtonItem *)sender
{
    //取消收藏和添加收藏
    if ([sender.image isEqual:[UIImage imageNamed:@"collection.png"]]) {
        
        [sender setImage:[UIImage imageNamed:@"uncollection.png"] ];
        NSFileManager* fileManager=[NSFileManager defaultManager];
        //获取文件名
        NSString *modelFileName = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:[NSString stringWithFormat:@"hero%@",self.modelname]];
         [fileManager removeItemAtPath:modelFileName error:nil];
        
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"取消收藏成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else{
        [sender setImage:[UIImage imageNamed:@"collection.png"] ];
    
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
        [archiver encodeObject:self.model forKey:@"heroModel"];
        [archiver finishEncoding];
    
        NSString *modelName = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:[NSString stringWithFormat:@"hero%@",self.modelname]];
        [data writeToFile:modelName atomically:YES];
        
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
#pragma mark--设置使用对抗技巧,背景故事
-(void)setTechAndStory
{
    
    self.storyArr=[[DetailManager shareInfoManager]getTechAndStoryArr];
    NSArray *arr = @[@"使用技巧",@"对抗技巧",@"简介及背景故事"];
    for (int i=0; i<3; i++) {
        UILabel *storyLabel = [[UILabel alloc]initWithFrame:CGRectMake(k_screenWidth*10, self.scrollViewHieght+k_screenWidth*15, k_screenWidth*130, k_screenWidth*30)];
        self.scrollViewHieght=k_screenWidth*15+k_screenWidth*30+self.scrollViewHieght;
        storyLabel.font=[UIFont systemFontOfSize:16];
        storyLabel.textAlignment=NSTextAlignmentLeft;
        storyLabel.textColor=[UIColor purpleColor];
        storyLabel.tag=10086+i;
        storyLabel.text=arr[i];
        [self.scrollView addSubview:storyLabel];
        
        UILabel *storyDesLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        storyDesLabel.tag=10010+i;
        storyDesLabel.text=self.storyArr[i];
        storyDesLabel.font=[UIFont systemFontOfSize:14];
        storyDesLabel.numberOfLines=0;
        NSDictionary *attribute4=@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGRect labelSize4 =[storyDesLabel.text boundingRectWithSize:CGSizeMake(k_screenWidth*345, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute4 context:nil];
        storyDesLabel.frame=CGRectMake(k_screenWidth*5,self.scrollViewHieght+k_screenWidth*15, k_screenWidth*345,labelSize4.size.height);
        storyDesLabel.layer.cornerRadius=5;
        self.scrollViewHieght=k_screenWidth*15+labelSize4.size.height+self.scrollViewHieght;
        [self.scrollView addSubview:storyDesLabel];
    }
    self.scrollView.contentSize = CGSizeMake(k_screenWidth*355,self.scrollViewHieght+k_screenWidth*100);
}
#pragma mark--设置头像属性等
-(void)setHerosAttribute
{
    //英雄头像
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(k_screenWidth*10, k_screenWidth*8, k_screenWidth*90, k_screenWidth*90)];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[DetailManager shareInfoManager] getSrcStr]]];
    imageV.image=[UIImage imageWithData:data];
    imageV.backgroundColor=[UIColor purpleColor];
    CALayer *layer = [imageV layer];
    layer.borderColor=[[UIColor blackColor]CGColor];
    layer.borderWidth=2.5;
    [self.view addSubview:imageV];
    //英雄名字
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(k_screenWidth*122, k_screenWidth*8, k_screenWidth*158, k_screenWidth*23)];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.text=[[DetailManager shareInfoManager]getName];
    nameLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:nameLabel];
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(k_screenWidth*290, k_screenWidth*8, k_screenWidth*45, k_screenWidth*23)];
    typeLabel.text = [[DetailManager shareInfoManager]getLocation];
    typeLabel.font = [UIFont systemFontOfSize:14];
    typeLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:typeLabel];
    //4种属性
    NSArray *arr=@[@"攻击",@"防御",@"法力",@"难度"];
    for (int i=0; i<4; i++) {
        UILabel *attributeLabel = [[UILabel alloc]initWithFrame:CGRectMake(k_screenWidth*120, k_screenWidth*31+k_screenWidth*17*i, k_screenWidth*30, k_screenWidth*15)];
        attributeLabel.textAlignment=NSTextAlignmentCenter;
        attributeLabel.font= [UIFont systemFontOfSize:12];
        attributeLabel.text = arr[i];
        [self.view addSubview:attributeLabel];
    }
    //属性进度条
    for (int i=0 ; i<4; i++) {
        UIProgressView *progressV = [[UIProgressView alloc]initWithFrame:CGRectMake(k_screenWidth*155, k_screenWidth*38+k_screenWidth*17*i, k_screenWidth*180, 0)];
        NSMutableArray *arr=[[DetailManager shareInfoManager]getColorArr];
        progressV.progress =[arr[i] floatValue]/100.0;
        progressV.transform=CGAffineTransformMakeScale(1.0, 3.4);
        progressV.progressTintColor=[UIColor redColor];
        switch (i) {
            case 0:
                progressV.progressTintColor=[UIColor redColor];
                break;
            case 1:
                progressV.progressTintColor=[UIColor greenColor];
                break;
            case 2:
                progressV.progressTintColor=[UIColor blueColor];
                break;
            case 3:
                progressV.progressTintColor=[UIColor purpleColor];
                break;
            default:
                break;
        }
        [self.view addSubview:progressV];
    }
}
-(NSMutableArray *)storyArr
{
    if (!_storyArr) {
        self.storyArr = [[NSMutableArray alloc]init];
    }
    return _storyArr;
}
-(NSMutableArray *)collectionArr
{
    if (!_collectionArr) {
        self.collectionArr = [[NSMutableArray alloc]init];
    }
    return _collectionArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end