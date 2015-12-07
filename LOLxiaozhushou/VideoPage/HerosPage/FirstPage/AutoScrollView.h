//
//  AutoScrollView.h
//  AutoScrollView
//
//  Created by 李国灏 on 15/11/5.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoScrollView : UIView

//记录当前是哪张图片
@property(nonatomic,assign)NSInteger currentPage;


-(instancetype)initWithFrame:(CGRect)frame Array:(NSMutableArray *)muArr;
//设置轮换间隔时间
-(void)setScrollViewTime:(NSTimeInterval)time;

-(void)doTime;


@end
