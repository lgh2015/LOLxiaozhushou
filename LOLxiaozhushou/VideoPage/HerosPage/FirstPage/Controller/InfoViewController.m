//
//  InfoViewController.m
//  项目
//
//  Created by 李国灏 on 15/11/28.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//
#import "InfoViewController.h"
#import "AutoScrollView.h"
#import "GeneralCell.h"
#import "ImformationManager.h"
#import "LoopScrollManager.h"
#import "NewsViewController.h"
#import "MJRefresh.h"



@interface InfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)AutoScrollView *autoSV;
@property(nonatomic,assign)NSInteger currentPage;
@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"111.png"] forBarMetrics:UIBarMetricsDefault];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:[GeneralCell class] forCellReuseIdentifier:@"cell"];
    self.currentPage=1;
    
    [self refresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSInteger num=0;
     num =[[ImformationManager shareManager]getArrCount];
    if (num==0) {
        [[LoopScrollManager shareManager]acquireData:@"http://qt.qq.com/static/pages/news/phone/c13_list_1.shtml" completion:^{
            NSMutableArray *arr = [[LoopScrollManager shareManager]getImageArr];
            self.autoSV=[[AutoScrollView alloc]initWithFrame:CGRectMake(0, k_screenWidth*100, k_screenWidth*375, k_screenWidth*180) Array:arr];
            [self.autoSV setScrollViewTime:2];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
            [self.autoSV addGestureRecognizer:tapGesture];
            self.tableView.tableHeaderView =self.autoSV;
        }];
        [[ImformationManager shareManager]acquireData:@"http://qt.qq.com/static/pages/news/phone/c12_list_1.shtml" completion:^{
            self.tableView.delegate=self;
            self.tableView.dataSource=self;
            [self.view addSubview:self.tableView];
        }];
    }
}

-(void)tapGestureAction:(UIGestureRecognizer *)sender
{
    NewsViewController *newsVC =[[NewsViewController alloc]init];
    NSLog(@"%ld",self.autoSV.currentPage);
    //因为这个currentPage是2到5的 现在要0到3 所以减二
    if (self.autoSV.currentPage==0) {
        newsVC.webViewStr = [[LoopScrollManager shareManager] getDetailArr][self.autoSV.currentPage];
        [self.navigationController pushViewController:newsVC animated:YES];
    }
    else{
        newsVC.webViewStr = [[LoopScrollManager shareManager] getDetailArr][self.autoSV.currentPage-2];
        [self.navigationController pushViewController:newsVC animated:YES];
    }
}

#pragma mark --上拉 下拉刷新
-(void)refresh
{
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(header)];
    [header setTitle:@"66666666666666" forState:MJRefreshStateRefreshing];
    [header setTitle:@"66666666666666" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"66666666666666" forState:MJRefreshStatePulling];

    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    //上拉刷新
    [self.tableView.mj_footer beginRefreshing];
    self.tableView.mj_footer =[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        self.currentPage+=1;
        NSLog(@"%ld",self.currentPage);
        if (self.currentPage<4) {
            [[ImformationManager shareManager]acquireData:[NSString stringWithFormat:@"http://qt.qq.com/static/pages/news/phone/c12_list_%ld.shtml",self.currentPage] completion:^{
                [self.tableView reloadData];
            }];
        }
        else{
            NSInteger page = 513-self.currentPage;
            if (page>0) {
                [[ImformationManager shareManager]acquireData:[NSString stringWithFormat:@"http://qt.qq.com/static/pages/news/phone/c12_list_n%ld.shtml",page] completion:^{
                    [self.tableView reloadData];
                }];
            }
        }
        [self.tableView.mj_footer endRefreshing];
    }];
}
-(void)header
{
    [[ImformationManager shareManager]acquireData:@"http://qt.qq.com/static/pages/news/phone/c12_list_1.shtml" completion:^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[ImformationManager shareManager]getArrCount];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return k_screenWidth*90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = [[ImformationManager shareManager]getModelByIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsViewController *newsVC = [[NewsViewController alloc]init];
    newsVC.webViewStr =[[ImformationManager shareManager]getModelByIndex:indexPath.row].article_url;
    [self.navigationController pushViewController:newsVC animated:YES];
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
