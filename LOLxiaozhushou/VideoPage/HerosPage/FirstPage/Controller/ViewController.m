//
//  ViewController.m
//  集合视图CollectionView
//
//  Created by 李国灏 on 15/10/20.
//  Copyright © 2015年 李国灏. All rights reserved.
//

#import "ViewController.h"
#import "DIYLayout.h"
#import "imageModel.h"
#import "CollectionViewCell.h"
#import "UIImageView+WebCache.h"
#define DATA_URL @"http://lolbox.oss.aliyuncs.com/json/tu/7/tu_108452.json?r=542358"
#define DATA_2 @"http://lolbox.oss.aliyuncs.com/json/tu/7/tu_86880.json?r=453340"

#define ITEM_WIDTH  (375-3*10)/2
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DIYLayoutDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UICollectionView *collectionV;
@property(nonatomic,strong)NSMutableArray* imageModelArr;
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UIScrollView *scrollV;
@property(nonatomic,assign)NSInteger selectPicIndex;
@end

@implementation ViewController


-(instancetype)init
{
    self =[super init];
    if (self) {
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, k_screenWidth*200, 44)];
        self.navigationItem.titleView=titleLabel;
        titleLabel.text=@"精美壁纸";
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[UIFont systemFontOfSize:22];
    }
    return self;
}

-(CGFloat)heightForItemWithIndexPath:(NSIndexPath *)indexPath{
    imageModel *image=self.imageModelArr[indexPath.row];
    CGFloat height=ITEM_WIDTH/[image.file_width floatValue]*[image.file_height floatValue];
    return height;
}
-(void)getData
{
    
    
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask=[session dataTaskWithURL:[NSURL URLWithString:DATA_URL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        //容错,当网络请求没有数据的时候,不崩溃
        if (!data) {
            return ;
        }
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        for (NSDictionary *dic in arr) {
    
            imageModel *image=[[imageModel alloc]init];
            [image setValuesForKeysWithDictionary:dic];
            
            [self.imageModelArr addObject:image];
        }
        
        NSURLSession *session2=[NSURLSession sessionWithConfiguration:config];
        NSURLSessionDataTask *dataTask2=[session2 dataTaskWithURL:[NSURL URLWithString:DATA_2] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!data) {
                return ;
            }
            NSArray *arr=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            for (NSDictionary *dic in arr) {
                
                imageModel *image=[[imageModel alloc]init];
                [image setValuesForKeysWithDictionary:dic];
                
                [self.imageModelArr addObject:image];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionV reloadData];
            });
        }];
        [dataTask2 resume];
        
    }];
    [dataTask resume];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    DIYLayout *mylayout=[[DIYLayout alloc ]init];
    
    mylayout.numberOfList=2;
    mylayout.itemSize=CGSizeMake(ITEM_WIDTH, 0);
    mylayout.sectionInsets=UIEdgeInsetsMake(k_screenWidth*10, k_screenWidth*10, k_screenWidth*10, k_screenWidth*10);
    mylayout.itemSpacing = 10;
    mylayout.delegate=self;
    
//    UICollectionView 集合视图
    self.collectionV=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:mylayout];
    [self.collectionV registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
    self.collectionV.delegate=self;
    self.collectionV.dataSource=self;
    [self.view addSubview:self.collectionV];
    self.imageModelArr=[NSMutableArray arrayWithCapacity:30];
    [self getData];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"111.png"] forBarMetrics:UIBarMetricsDefault];
}

//每个分区有几个item
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageModelArr.count;
}

//每个item显示什么样的cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    
    imageModel *imageModel=self.imageModelArr[indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.url]];
    
    return cell;
}

#pragma mark--点击方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectPicIndex=indexPath.row;
    UIView *backView =[[UIView alloc]initWithFrame:self.view.bounds];
    backView.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.65];
    [self.view addSubview:backView];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [backView addGestureRecognizer:tapGesture];
    
    self.scrollV =[[UIScrollView alloc]initWithFrame:CGRectMake(0, k_screenWidth*-10, k_screenWidth*375,k_screenWidth* 500)];
    self.scrollV.contentSize=CGSizeMake(k_screenWidth*375*self.imageModelArr.count, k_screenWidth*500);
    self.scrollV.pagingEnabled=YES;
    self.scrollV.delegate=self;
    self.scrollV.showsHorizontalScrollIndicator=NO;
    self.scrollV.showsVerticalScrollIndicator=NO;
    [backView addSubview:self.scrollV];
    
    for (int i=0; i<self.imageModelArr.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i*k_screenWidth*375, 0, k_screenWidth*375, k_screenWidth*500)];
        [imageV sd_setImageWithURL:[self.imageModelArr[i] url]];
        imageV.contentMode=UIViewContentModeScaleAspectFit;
        imageV.tag=i+10086;
        [self.scrollV addSubview:imageV];
    }
    self.scrollV.contentOffset=CGPointMake(k_screenWidth*indexPath.row*375, 0);
    
    UIButton *button =[[UIButton alloc]initWithFrame:CGRectMake(k_screenWidth*310, k_screenWidth*470, k_screenWidth*30, k_screenWidth*30)];
    [button setBackgroundImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
}

-(void)downloadAction:(UIButton *)sender
{
    /**
     *  将图片保存到iPhone本地相册
     *  UIImage *image            图片对象
     *  id completionTarget       响应方法对象
     *  SEL completionSelector    方法
     *  void *contextInfo
     */
    UIImageView *selectImageV =[self.scrollV viewWithTag:self.selectPicIndex+10086];
    UIImageWriteToSavedPhotosAlbum(selectImageV.image,self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        
        UIAlertController *alertC =[UIAlertController alertControllerWithTitle:@"提示" message:@"已存入手机相册" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    else{
        UIAlertController *alertC =[UIAlertController alertControllerWithTitle:@"提示" message:@"保存失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.selectPicIndex=scrollView.contentOffset.x/k_screenWidth*375;
}
-(void)tapAction:(UITapGestureRecognizer *)sender
{
    [sender.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
