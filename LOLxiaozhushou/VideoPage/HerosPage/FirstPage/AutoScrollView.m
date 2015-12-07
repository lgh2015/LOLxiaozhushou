//
//  AutoScrollView.m
//  AutoScrollView
//
//  Created by 李国灏 on 15/11/5.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "AutoScrollView.h"
#import "LoopScrollManager.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@interface AutoScrollView ()<UIScrollViewDelegate>
//设置定时器
@property(nonatomic,strong)NSTimer *timer;
//设置scrollView
@property(nonatomic,strong)UIScrollView *scrollView;
//设置pageControl
@property(nonatomic,strong)UIPageControl  *pageControl;

@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation AutoScrollView
#pragma mark--初始化方法
-(instancetype)initWithFrame:(CGRect)frame Array:(NSMutableArray *)muArr
{
    self=[super initWithFrame:frame];
    if (self) {
        self.currentPage=0;
        [self insertScrollView];
        [self insertImage:muArr];
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, k_screenWidth*180-SCREENWIDTH/375*20, SCREENWIDTH, SCREENWIDTH/375*20)];
        backView.backgroundColor =[UIColor colorWithWhite:0.8 alpha:0.8];
        [self addSubview:backView];
         self.titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/375*9, k_screenWidth*180-SCREENWIDTH/375*20, SCREENWIDTH, SCREENWIDTH/375*20)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.text=[[LoopScrollManager shareManager]getTitleArr][self.currentPage];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.titleLabel];
        [self insertPageControl];

    }
    return self;
}
#pragma mark--设置ScrollView
-(void)insertScrollView
{
    self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, k_screenWidth*180)];
    self.scrollView.contentSize=CGSizeMake(SCREENWIDTH*6, k_screenWidth*180);
    self.scrollView.pagingEnabled=YES;
    self.scrollView.delegate=self;
    self.scrollView.contentOffset=CGPointMake(SCREENWIDTH,0);
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.scrollsToTop=NO;
    [self addSubview:self.scrollView];
}
#pragma mark--设置PageControl
-(void)insertPageControl
{
    self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(SCREENWIDTH/5*4, k_screenWidth*180-SCREENWIDTH/375*20, SCREENWIDTH/5, SCREENWIDTH/375*20)];
    self.pageControl.numberOfPages=4;
    self.pageControl.currentPageIndicatorTintColor=[UIColor darkGrayColor];
    [self.pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
}
//pageControl触发的方法
-(void)pageControlAction:(UIPageControl *)pageControl
{
    //通过改变点去确定是第几张图片
    self.scrollView.contentOffset=CGPointMake(SCREENWIDTH*pageControl.currentPage, 0);
}

#pragma mark--开始滚动的方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //图片的轮换使点发生变化
    self.pageControl.currentPage=(scrollView.contentOffset.x+SCREENWIDTH/2)/SCREENWIDTH-1;
}
#pragma mark--拖动结束时候的方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //第一页的偏移量设置为第五页
    if (self.scrollView.contentOffset.x==0) {
        self.scrollView.contentOffset=CGPointMake(SCREENWIDTH*4, 0);
    }
    if (self.scrollView.contentOffset.x==375*5) {
        self.scrollView.contentOffset=CGPointMake(SCREENWIDTH, 0);
    }
    //拖动后更新当前的页数
    self.currentPage=self.scrollView.contentOffset.x/SCREENWIDTH+1;
    if (self.currentPage>=2) {
        self.titleLabel.text=[[LoopScrollManager shareManager]getTitleArr][self.currentPage-2];
    }
}

#pragma mark--设置将数组里面的图片加到scrollView上
-(void)insertImage:(NSMutableArray *)muArr
{
    //添加第一张
    UIImageView *imageVF=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, k_screenWidth*180)];
    imageVF.image=muArr[0];
    [self.scrollView addSubview:imageVF];
    for (int i=1; i<muArr.count-1;i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(k_screenWidth*375*(i), 0, SCREENWIDTH, k_screenWidth*180)];
        imageView.image =muArr[i];
        [self.scrollView addSubview:imageView];
    }
    //添加最后一张
    UIImageView *imageVl=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH*5, 0, SCREENWIDTH, k_screenWidth*180)];
    imageVl.image=muArr[muArr.count-1];
    [self.scrollView addSubview:imageVl];
}

#pragma mark--设置定时器,设置轮换间隔
-(void)setScrollViewTime:(NSTimeInterval)time
{
    self.timer=[NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(doTime) userInfo:nil repeats:YES];
}
#pragma mark--定时器执行的方法
-(void)doTime
{
    //在第5张的时候回到第2张,实现轮播
    if (self.currentPage%5==0&&self.currentPage!=1) {
        self.currentPage=1;
    }
    self.scrollView.contentOffset=CGPointMake(SCREENWIDTH*self.currentPage, 0);
    self.currentPage++;
    self.titleLabel.text=[[LoopScrollManager shareManager]getTitleArr][self.currentPage-2];
}












@end
