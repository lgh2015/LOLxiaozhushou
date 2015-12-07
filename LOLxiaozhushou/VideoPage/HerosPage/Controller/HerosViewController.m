//
//  HerosViewController.m
//  项目
//
//  Created by 李国灏 on 15/10/28.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "HerosViewController.h"
#import "HerosCell.h"
#import "HerosDetailViewController.h"
#import "HerosManager.h"
#import "HerosModel.h"


@interface HerosViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate>
@property(nonatomic,strong)NSMutableArray *nameModelArr;
@property(nonatomic,strong)NSMutableArray *searchNameArr;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *buttonArr;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)NSMutableArray *collectionArr;
@end

@implementation HerosViewController
#pragma mark --初始化方法

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //用一个label来设置导航栏的字体
        {
            UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, k_screenWidth*200, 44)];
            titleLable.backgroundColor=[UIColor clearColor];
            titleLable.textAlignment=NSTextAlignmentCenter;
            titleLable.text=@"英雄攻略";
            titleLable.font=[UIFont systemFontOfSize:22];
            self.navigationItem.titleView=titleLable;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *background = [[UIImageView alloc]initWithFrame:self.view.bounds];
    background.image=[UIImage imageNamed:@"jie.jpg"];
    [self.view addSubview:background];
    UIVisualEffectView *visualView=[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualView.frame=[UIScreen mainScreen].bounds;
    //7.模糊效果对谁起作用
    [background addSubview:visualView];
    
    [self addThreeBtn];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"111.png"] forBarMetrics:UIBarMetricsDefault];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSMutableArray *arr=[[HerosManager shareInfoManager]getHerosArr];
    if (arr.count==0) {
        [[HerosManager shareInfoManager]acquireDataCompletion:^{
            [self addCollectionV];
            self.nameModelArr=[[HerosManager shareInfoManager]getHerosArr];
            self.searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(k_screenWidth*10, k_screenWidth*30,k_screenWidth* 355,k_screenWidth* 30)];
            self.searchBar.delegate=self;
            self.searchBar.barStyle=UIBarStyleBlack;
            self.searchBar.showsCancelButton=YES;
            self.searchBar.placeholder=@"请输入英雄名字";
            self.searchBar.backgroundColor=[UIColor redColor];
            [self.view addSubview:self.searchBar];
            self.collectionView.frame=CGRectMake(0,k_screenWidth* 60,k_screenWidth* 375, k_screenWidth*(667-124-49));
        }];
    }
}

#pragma mark--添加周免 全部 收藏三个按钮
-(void)addThreeBtn
{
    //设置3个按钮
    {
        self.buttonArr=[[NSMutableArray alloc]init];
        NSArray *titleArr=[[NSArray alloc]initWithObjects:@"全部",@"周免",@"收藏", nil];
        for (int i=0; i<3; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(i*k_screenWidth*375/3, 0, k_screenWidth*375/3, k_screenWidth*30);
            button.backgroundColor=[UIColor clearColor];
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor purpleColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchDown];
            [self.buttonArr addObject:button];
            [self.view addSubview:button];
        }
    }
    //设置一进来就是选择第一个选项(常用)
    UIButton *b= self.buttonArr[0];
    b.selected=YES;
}
#pragma mark--布局集合视图CollectionView
-(void)addCollectionV
{
    //布局集合视图
    UICollectionViewFlowLayout *flowLaout=[[UICollectionViewFlowLayout alloc]init];
    flowLaout.minimumLineSpacing=k_screenWidth*35;
    flowLaout.minimumInteritemSpacing=k_screenWidth*25;
    flowLaout.scrollDirection=UICollectionViewScrollDirectionVertical;
    flowLaout.itemSize=CGSizeMake(k_screenWidth*70, k_screenWidth*84);
    //设置分区中距离上下左右的距离
    flowLaout.sectionInset=UIEdgeInsetsMake(k_screenWidth*10, k_screenWidth*10, k_screenWidth*10, k_screenWidth*10);
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, k_screenWidth*30, k_screenWidth*375, k_screenWidth*(667-64-49)) collectionViewLayout:flowLaout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor=[UIColor clearColor];
    [self.collectionView registerClass:[HerosCell class] forCellWithReuseIdentifier:@"herosuse"];
    [self.view addSubview:self.collectionView];
}
#pragma mark 点击按钮时触发的方法,带有搜索栏
-(void)ButtonAction:(UIButton *)sender
{
    for (UIButton *btn in self.buttonArr) {
        btn.selected=NO;
    }
    if ([sender.titleLabel.text isEqualToString:@"全部"]&&self.searchBar==nil) {
        self.searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(k_screenWidth*10, k_screenWidth*30,k_screenWidth* 355,k_screenWidth* 30)];
        self.searchBar.delegate=self;
        self.searchBar.barStyle=UIBarStyleBlack;
        self.searchBar.showsCancelButton=YES;
        self.searchBar.placeholder=@"请输入英雄名字";
        self.searchBar.backgroundColor=[UIColor redColor];
        [self.view addSubview:self.searchBar];
        self.collectionView.frame=CGRectMake(0,k_screenWidth* 60,k_screenWidth* 375, k_screenWidth*(667-124-49));
        self.nameModelArr =[[HerosManager shareInfoManager]getHerosArr];
        [self.collectionView reloadData];
    }
    else if ([sender.titleLabel.text isEqualToString:@"周免"])
    {
        self.nameModelArr =[[HerosManager shareInfoManager]getFreeArr];
        [self.collectionView reloadData];
        //当回到周免 那些选项的时候移除搜索栏
        [self.searchBar removeFromSuperview];
        self.searchBar=nil;
        self.collectionView.frame=CGRectMake(0, k_screenWidth*30,k_screenWidth* 375,k_screenWidth* (667-94-49));
    }
    else if([sender.titleLabel.text isEqualToString:@"收藏"])
    {
        //实现收藏的英雄显示
        [self.collectionArr removeAllObjects];
        for (NSString *name in [[HerosManager shareInfoManager]getNameArr]) {
            NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:[NSString stringWithFormat:@"hero%@",name]];
            NSData *data =[[NSData alloc]initWithContentsOfFile:filePath];
            if (data!=nil) {
                NSKeyedUnarchiver *unarchiver =[[NSKeyedUnarchiver alloc]initForReadingWithData:data];
                HerosModel *model =[unarchiver decodeObjectForKey:@"heroModel"];
                [self.collectionArr addObject:model];
            }
        }
        self.nameModelArr =self.collectionArr;
        [self.searchBar removeFromSuperview];
        self.searchBar=nil;
        self.collectionView.frame=CGRectMake(0,k_screenWidth* 30,k_screenWidth* 375,k_screenWidth* (667-94-49));
        [self.collectionView reloadData];
    }
    else{
    }
    sender.selected=YES;
}
#pragma -mark  取消按钮触发方法  回收键盘
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text=@"";
    [self.searchBar resignFirstResponder];
    self.nameModelArr = [[HerosManager shareInfoManager]getHerosArr];
    [self.collectionView reloadData];
}
#pragma -mark 实时变化 每打一个字母都能改变搜索的东西
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //如果没有搜索  就显示全部
    if ([searchText isEqualToString:@""]) {
        self.nameModelArr = [[HerosManager shareInfoManager]getHerosArr];
    }
    else
    {
        //将所有名字加进一个数组,用searchText去匹配一样的,再改变显示存储英雄的数组
        self.searchNameArr=[[NSMutableArray alloc]init];
        for (HerosModel *model in [[HerosManager shareInfoManager]getHerosArr]) {
            if ([model.herosName containsString:searchText]) {
                [self.searchNameArr addObject:model];
            }
        }
        self.nameModelArr = self.searchNameArr;
    }
    [self.collectionView reloadData];
}
#pragma -mark 设置集合视图的cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HerosCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"herosuse" forIndexPath:indexPath];
    if (self.nameArr.count>0) {
        cell.model=self.nameArr[indexPath.row];
    }
    return cell;
}
//有多少个collectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.nameArr.count;
}

#pragma -mark 点击方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HerosDetailViewController *herosDetailVC=[[HerosDetailViewController alloc]init];
    HerosModel *model = self.nameArr[indexPath.row];
    //收起标签视图
    herosDetailVC.hidesBottomBarWhenPushed=YES;
    herosDetailVC.modelname = model.herosName;
    herosDetailVC.detailStr = [NSString stringWithFormat:@"http://cha.17173.com%@",model.herosDetail];
    herosDetailVC.model = model;
    [self.navigationController pushViewController:herosDetailVC animated:YES];
}
-(NSMutableArray *)nameArr
{
    if (_nameModelArr ==nil) {
        self.nameModelArr =[[NSMutableArray alloc]init];
    }
    return _nameModelArr;
}
-(NSMutableArray *)collectionArr
{
    if (_collectionArr==nil) {
        self.collectionArr=[[NSMutableArray alloc]init];
    }
    return _collectionArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
