//
//  EventViewController.m
//  项目
//
//  Created by 李国灏 on 15/11/28.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "EventViewController.h"
#import "GeneralCell.h"
#import "EventManager.h"
#import "NewsViewController.h"
#import "MJRefresh.h"

@interface EventViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)NSInteger currentPage;
@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage=1;
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-k_screenWidth*108) style:UITableViewStylePlain];
    [self.tableView registerClass:[GeneralCell class] forCellReuseIdentifier:@"cell"];
    [[EventManager shareManager]acquireData:@"http://qt.qq.com/static/pages/news/phone/c73_list_1.shtml" completion:^{
        self.tableView.delegate =self;
        self.tableView.dataSource=self;
        [self.view addSubview:self.tableView];
    }];
    
    
    [self refresh];
}

#pragma mark --上拉 下拉刷新
-(void)refresh
{
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(header)];
    [header setTitle:@"66666666666666" forState:MJRefreshStateRefreshing];
    [header setTitle:@"66666666666666" forState:MJRefreshStateWillRefresh];
    self.tableView.mj_header=header;
    [self.tableView.mj_header beginRefreshing];
    
    
    [self.tableView.mj_footer beginRefreshing];
    self.tableView.mj_footer =[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        self.currentPage+=1;
        NSLog(@"%ld",self.currentPage);
        if (self.currentPage<4) {
            [[EventManager shareManager]acquireData:[NSString stringWithFormat:@"http://qt.qq.com/static/pages/news/phone/c73_list_%ld.shtml",self.currentPage] completion:^{
                [self.tableView reloadData];
            }];
        }
        else{
            NSInteger page = 126-self.currentPage;
            if (page>0) {
                [[EventManager shareManager]acquireData:[NSString stringWithFormat:@"http://qt.qq.com/static/pages/news/phone/c73_list_n%ld.shtml",page] completion:^{
                    [self.tableView reloadData];
                }];
            }
        }
        [self.tableView.mj_footer endRefreshing];
    }];
}
-(void)header
{
    [[EventManager shareManager]acquireData:@"http://qt.qq.com/static/pages/news/phone/c73_list_1.shtml" completion:^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[EventManager shareManager]getArrCount];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return k_screenWidth*90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = [[EventManager shareManager]getModelByIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsViewController *newsVC =[[NewsViewController alloc]init];
    newsVC.webViewStr = [[EventManager shareManager]getModelByIndex:indexPath.row].article_url;
    [self.navigationController pushViewController:newsVC animated:YES];
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
