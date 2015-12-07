//
//  VideoViewController.m
//  项目
//
//  Created by 李国灏 on 15/10/28.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "VideoViewController.h"
#import "videoCells.h"
#import "VideoDetailController.h"
#import "VideoManager.h"
#import "MJRefresh.h"
#import "talkVideoManager.h"

@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,strong)UISegmentedControl *segment;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"111.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:[videoCells class] forCellReuseIdentifier:@"videoreuse"];
    
    [[VideoManager shareInfoManager]acquireData:@"http://lol.178.com/list/video.html" Completion:^{
        [self setSegmentControl];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        [self.view addSubview:_tableView];
    }];
   
    
    
    [self mjRefresh];
}
-(void)setSegmentControl
{
    
    self.segment=[[UISegmentedControl alloc]initWithItems:@[@"最新视频",@"精彩操作"]];
    self.segment.selectedSegmentIndex=0;
    self.segment.tintColor=[UIColor blackColor];
    self.segment.frame=CGRectMake(0, 0, k_screenWidth*200, k_screenHeight*30);
    self.navigationItem.titleView=self.segment;
    [self.segment addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
}
-(void)segmentedControlAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex==0) {
        [[VideoManager shareInfoManager]acquireData:@"http://lol.178.com/list/video.html" Completion:^{
            [self.tableView reloadData];
        }];
    }
    else
    {
        [[talkVideoManager shareInfoManager]acquireData:@"http://lol.178.com/list/jisha/" Completion:^{
            [self.tableView reloadData];
        }];
    }
}

-(void)mjRefresh
{
    
    MJRefreshStateHeader *header =[MJRefreshStateHeader  headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [header setTitle:@"6666666666666666" forState:MJRefreshStateRefreshing];
    [header setTitle:@"6666666666666666" forState:MJRefreshStateWillRefresh];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer  = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self.tableView.mj_footer beginRefreshing];
        self.currentPage +=1;
        if (self.segment.selectedSegmentIndex==0) {
            
            if (self.currentPage<50) {

                [[VideoManager shareInfoManager]acquireData:[NSString stringWithFormat:@"http://lol.178.com/list/video_%ld.html",self.currentPage+1] Completion:^{
                    [self.tableView reloadData];
                }];
            }
        }
        else
        {
            if (self.currentPage<50) {

            [[talkVideoManager shareInfoManager]acquireData:[NSString stringWithFormat:@"http://lol.178.com/list/jisha/index_%ld.html",self.currentPage+1] Completion:^{
                [self.tableView reloadData];
            }];
            }
        }
        
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)headerRefresh
{
    if (self.segment.selectedSegmentIndex==0) {
        [[VideoManager shareInfoManager]acquireData:@"http://lol.178.com/list/video.html" Completion:^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        }];
    }
    else
    {
        [[talkVideoManager shareInfoManager]acquireData:@"http://lol.178.com/list/jisha/" Completion:^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }];
    }
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segment.selectedSegmentIndex==0) {
        if (self.currentPage<50) {

        return  [[VideoManager shareInfoManager]getArrCount];
        }
    }
    else
    {
        if (self.currentPage<50) {

        return  [[talkVideoManager shareInfoManager]getArrCount];
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    videoCells *cell=[tableView dequeueReusableCellWithIdentifier:@"videoreuse" forIndexPath:indexPath];
    if (self.segment.selectedSegmentIndex==0) {
        if (self.currentPage<50) {
        cell.model = (VideoModel *)[[VideoManager shareInfoManager]getModelArr:indexPath.row];
        }
    }
    else{
        if (self.currentPage<50) {
        cell.model = (VideoModel *)[[talkVideoManager shareInfoManager]getModelArr:indexPath.row];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex==0) {
        VideoModel *model =(VideoModel *)[[VideoManager shareInfoManager]getModelArr:indexPath.row];
        VideoDetailController *VideoDetailVC=[[VideoDetailController alloc]init];
        VideoDetailVC.detailStr=model.detail;
        VideoDetailVC.title11 = model.title;
        VideoDetailVC.shareImage=model.picture;
        [self.navigationController pushViewController:VideoDetailVC animated:YES];
    }
    else
    {
        VideoModel *model =(VideoModel *)[[talkVideoManager shareInfoManager]getModelArr:indexPath.row];
        VideoDetailController *VideoDetailVC=[[VideoDetailController alloc]init];
        VideoDetailVC.detailStr=model.detail;
        VideoDetailVC.title11 = model.title;
        VideoDetailVC.shareImage=model.picture;
        [self.navigationController pushViewController:VideoDetailVC animated:YES];
    }
    
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
