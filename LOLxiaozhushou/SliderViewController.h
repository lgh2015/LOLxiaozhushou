//
//  SliderViewController.h
//  左拉菜单升级
//
//  Created by lanou on 15/10/30.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderViewController : UIViewController


// 主页的试图控制器属性
@property (nonatomic, strong) UIViewController *MainVC;

// 左视图控制器属性
@property (nonatomic, strong) UIViewController *LeftVC;


// 最终主页视图X的偏移量
@property (nonatomic, assign) CGFloat offsetX;


// 最终主页视图的高度
@property (nonatomic, assign) CGFloat MainLastHegiht;

// 背景图
@property (nonatomic, strong) UIImageView *bgImageView;



// 设置推出左视图控制器按钮的文字
- (void)setPushLeftViewButtonWithString:(NSString *)string;

// 设置推出左视图控制器按钮的图片
- (void)setPushLeftViewButtonWithImage:(UIImage *)image;





- (instancetype)initWithRootVC:(UIViewController *)rootVC;














@end
