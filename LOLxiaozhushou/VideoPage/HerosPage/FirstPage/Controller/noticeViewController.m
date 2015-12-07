//
//  noticeViewController.m
//  项目
//
//  Created by 李国灏 on 15/12/4.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "noticeViewController.h"
#import "NoticeManager.h"
#import "GeneralCell.h"
#import "NewsViewController.h"
#import "MJRefresh.h"

@interface noticeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tabelView;

@property(nonatomic,assign)NSInteger currentPage;
@end

@implementation noticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabelView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, k_screenWidth*375, k_screenWidth*(667-108)) style:UITableViewStylePlain];
    [self.tabelView registerClass:[GeneralCell class] forCellReuseIdentifier:@"cell"];
    self.currentPage=1;
    [[NoticeManager shareManager]acquireData:@"http://qt.qq.com/static/pages/news/phone/c3_list_1.shtml" completion:^{
        self.tabelView.delegate =self;
        self.tabelView.dataSource=self;
        [self.view addSubview:self.tabelView];
    }];
    
    [self refresh];
    
}
#pragma mark --上拉 下拉刷新
-(void)refresh
{
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(header)];
    [header setTitle:@"66666666666666" forState:MJRefreshStateRefreshing];
    [header setTitle:@"66666666666666" forState:MJRefreshStateWillRefresh];
    self.tabelView.mj_header=header;
    [self.tabelView.mj_header beginRefreshing];
    
    
    [self.tabelView.mj_footer beginRefreshing];
    self.tabelView.mj_footer =[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        self.currentPage+=1;
        NSLog(@"%ld",self.currentPage);
        if (self.currentPage<4) {
            [[NoticeManager shareManager]acquireData:[NSString stringWithFormat:@"http://qt.qq.com/static/pages/news/phone/c3_list_%ld.shtml",self.currentPage] completion:^{
                [self.tabelView reloadData];
            }];
        }
        else{
            NSInteger page = 63-self.currentPage;
            if (page>0) {
                [[NoticeManager shareManager]acquireData:[NSString stringWithFormat:@"http://qt.qq.com/static/pages/news/phone/c3_list_n%ld.shtml",page] completion:^{
                    [self.tabelView reloadData];
                }];
            }
        }
        [self.tabelView.mj_footer endRefreshing];
    }];
}

-(void)header
{
    [[NoticeManager shareManager]acquireData:@"http://qt.qq.com/static/pages/news/phone/c3_list_1.shtml" completion:^{
        [self.tabelView reloadData];
        [self.tabelView.mj_header endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[NoticeManager shareManager]getArrCount];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return k_screenWidth*90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = [[NoticeManager shareManager]getModelByIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tabelView deselectRowAtIndexPath:indexPath animated:YES];
    NewsViewController *newsVC =[[NewsViewController alloc]init];
    newsVC.webViewStr = [[NoticeManager shareManager]getModelByIndex:indexPath.row].article_url;
    [self.navigationController pushViewController:newsVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
